import 'dart:async';
import 'dart:math';
import '../models/sensor_reading.dart';
import 'tflite_service.dart';

enum FallStatus { normal, fallDetected }

class FallDetectionService {
  // Demo values: 2 s at 10 Hz. The real bracelet would be 400 samples at 200 Hz.
  static const int windowSize = 20;
  static const int inferenceEvery = 10;

  final _random = Random();
  final _tflite = TfliteService();
  final _readingController = StreamController<SensorReading>.broadcast();
  final _statusController = StreamController<FallStatus>.broadcast();
  final _probController = StreamController<double>.broadcast();
  final List<SensorReading> _window = [];
  Timer? _timer;
  bool _spikeNext = false;
  bool _latched = false;
  bool _disposed = false;
  int _sinceLastInference = 0;

  Stream<SensorReading> get readings => _readingController.stream;
  Stream<FallStatus> get status => _statusController.stream;
  Stream<double> get modelProbability => _probController.stream;

  Future<void> start() async {
    try {
      await _tflite.load();
    } catch (e) {
      // ignore: avoid_print
      print('Model load failed: $e');
    }
    if (_disposed) return;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final reading = _generateReading();
      _readingController.add(reading);

      _window.add(reading);
      if (_window.length > windowSize) _window.removeAt(0);
      _sinceLastInference++;
      if (_tflite.isLoaded &&
          _window.length == windowSize &&
          _sinceLastInference >= inferenceEvery) {
        _sinceLastInference = 0;
        _probController.add(
          _tflite.predictFallProbability(_extractFeatures(_window)),
        );
      }

      if (_classify(reading) == FallStatus.fallDetected) _latched = true;
      _statusController.add(
        _latched ? FallStatus.fallDetected : FallStatus.normal,
      );
    });
  }

  void simulateFall() => _spikeNext = true;

  void resetAlert() => _latched = false;

  // The alert still uses a simple threshold because the placeholder model
  // has arbitrary weights. Switch to the model output once the real one is trained.
  FallStatus _classify(SensorReading r) {
    return r.accMagnitude > 2.5 ? FallStatus.fallDetected : FallStatus.normal;
  }

  // 9 axes x 5 stats = 45 features.
  // Axes 7-9 are zero-padded for now (the MPU6050 only gives 6 axes).
  // TODO: match the exact feature order and scaler from the training pipeline.
  List<double> _extractFeatures(List<SensorReading> w) {
    final n = w.length;
    final axes = <List<double>>[
      w.map((r) => r.ax).toList(),
      w.map((r) => r.ay).toList(),
      w.map((r) => r.az).toList(),
      w.map((r) => r.gx).toList(),
      w.map((r) => r.gy).toList(),
      w.map((r) => r.gz).toList(),
      List.filled(n, 0.0),
      List.filled(n, 0.0),
      List.filled(n, 0.0),
    ];

    final features = <double>[];
    for (final a in axes) {
      final mean = a.reduce((x, y) => x + y) / n;
      final variance =
          a.map((v) => (v - mean) * (v - mean)).reduce((x, y) => x + y) / n;
      features.addAll([
        mean,
        sqrt(variance),
        a.reduce(max),
        a.reduce(min),
        a.map((v) => v * v).reduce((x, y) => x + y),
      ]);
    }
    return features;
  }

  // TODO: replace with real BLE data from the ESP32
  SensorReading _generateReading() {
    double noise() => (_random.nextDouble() - 0.5) * 0.1;
    if (_spikeNext) {
      _spikeNext = false;
      return SensorReading(
        ax: 2.8, ay: 1.5, az: 1.0,
        gx: 220, gy: 180, gz: 90,
        time: DateTime.now(),
      );
    }
    return SensorReading(
      ax: noise(), ay: noise(), az: 1.0 + noise(),
      gx: noise() * 10, gy: noise() * 10, gz: noise() * 10,
      time: DateTime.now(),
    );
  }

  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _tflite.dispose();
    _readingController.close();
    _statusController.close();
    _probController.close();
  }
}
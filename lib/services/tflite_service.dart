import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteService {
  Interpreter? _interpreter;

  bool get isLoaded => _interpreter != null;

  Future<void> load() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/models/fall_detection_placeholder.tflite',
    );
  }

  /// [features] must have 45 values. Returns the fall probability (0..1).
  double predictFallProbability(List<double> features) {
    final output = [List<double>.filled(2, 0.0)]; // shape [1, 2]
    _interpreter!.run([features], output); // input shape [1, 45]
    return output[0][1]; // assumes index 1 = "fall"
  }

  void dispose() => _interpreter?.close();
}
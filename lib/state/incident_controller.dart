import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/fall_detection_service.dart';

class IncidentController extends ChangeNotifier {
  final FallDetectionService service;
  StreamSubscription<FallStatus>? _sub;
  Timer? _timer;
  bool _active = false;
  int _seconds = 0;
  DateTime? _detectedAt;

  IncidentController(this.service) {
    _sub = service.status.listen((s) {
      if (s == FallStatus.fallDetected && !_active) _start();
    });
  }

  bool get active => _active;
  DateTime? get detectedAt => _detectedAt;

  String get formatted {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void simulateFall() => service.simulateFall();

  void _start() {
    _active = true;
    _seconds = 0;
    _detectedAt = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _seconds++;
      notifyListeners();
    });
    notifyListeners();
  }

  void acknowledge() {
    // TODO: write this incident (detectedAt, response time) to the Firestore audit log
    _timer?.cancel();
    _timer = null;
    _active = false;
    _seconds = 0;
    service.resetAlert();
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}
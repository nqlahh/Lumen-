import 'dart:math';

class SensorReading {
  final double ax, ay, az; // accelerometer (g)
  final double gx, gy, gz; // gyroscope (deg/s)
  final DateTime time;

  const SensorReading({
    required this.ax,
    required this.ay,
    required this.az,
    required this.gx,
    required this.gy,
    required this.gz,
    required this.time,
  });

  double get accMagnitude => sqrt(ax * ax + ay * ay + az * az);
}
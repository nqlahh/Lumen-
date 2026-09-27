import 'package:flutter/material.dart';
import '../models/sensor_reading.dart';
import '../services/fall_detection_service.dart';
import '../state/incident_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';

class MonitorScreen extends StatelessWidget {
  final FallDetectionService service;
  final IncidentController incident;

  const MonitorScreen({
    super.key,
    required this.service,
    required this.incident,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        _PatientCard(incident: incident),
        _PositionCard(incident: incident),
        _StopwatchCard(incident: incident),
        _AckButton(incident: incident),
        const SizedBox(height: 10),
        Center(
          child: Text(
            'Two-step confirmation required',
            style: AppText.mono(size: 10, color: AppColors.inkFaint, ls: 0.4),
          ),
        ),
        const SizedBox(height: 16),
        _EdgeAiCard(service: service),
      ],
    );
  }
}

class _PatientCard extends StatelessWidget {
  final IncidentController incident;
  const _PatientCard({required this.incident});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.person,
                size: 36,
                color: AppColors.inkFaint,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Puan Aishah bt Rahman',
                    style: AppText.serif(size: 22, ls: -0.44, height: 1.1),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '78 yrs · Ward 2B · Room 14',
                    style: AppText.mono(size: 11.5, color: AppColors.inkSoft),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'PT-2024-089 · Bracelet 24:0A:C4:5F:8B:21',
                    style: AppText.mono(
                      size: 10,
                      color: AppColors.inkFaint,
                      ls: 0.2,
                    ),
                  ),
                  const SizedBox(height: 9),
                  ListenableBuilder(
                    listenable: incident,
                    builder: (_, __) =>
                        _StatusBadge(emergency: incident.active),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool emergency;
  const _StatusBadge({required this.emergency});

  @override
  Widget build(BuildContext context) {
    final fg = emergency ? Colors.white : AppColors.emerald;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: emergency ? AppColors.crimson : AppColors.emeraldSoft,
        border: Border.all(
          color: emergency ? AppColors.crimson : AppColors.emeraldBorder,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              emergency ? 'EMERGENCY · FALL DETECTED' : 'NORMAL · STANDING',
              style: AppText.mono(
                size: 9.5,
                color: fg,
                weight: FontWeight.w600,
                ls: 0.76,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionCard extends StatelessWidget {
  final IncidentController incident;
  const _PositionCard({required this.incident});

  String _time(DateTime? t) {
    if (t == null) return '14:27:08 MYT';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}:${two(t.second)} MYT';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: incident,
      builder: (_, __) => AppCard(
        title: 'Last known position',
        meta: _time(incident.detectedAt),
        child: const Column(
          children: [
            _MapView(),
            _GpsGrid(),
          ],
        ),
      ),
    );
  }
}

class _MapView extends StatelessWidget {
  const _MapView();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: const BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: AppColors.border)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: CustomPaint(painter: const _MapPainter())),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0x1ADC2626),
              border: Border.all(color: const Color(0x40DC2626)),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -15),
            child: const Icon(
              Icons.location_on,
              color: AppColors.crimson,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF1F5F9));

    final grid = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    for (double x = 0; x <= w; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), grid);
    }
    for (double y = 0; y <= h; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(w, y), grid);
    }

    Paint road(double width) => Paint()
      ..color = AppColors.borderStrong
      ..strokeWidth = width;
    canvas.drawLine(Offset(0, h * 0.54), Offset(w, h * 0.54), road(6));
    canvas.drawLine(Offset(w * 0.45, 0), Offset(w * 0.45, h), road(4));
    canvas.drawLine(Offset(w * 0.8, 0), Offset(w * 0.8, h), road(3));

    final blockFill = Paint()..color = AppColors.border;
    final blockLine = Paint()
      ..color = AppColors.borderStrong
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final blocks = <Rect>[
      Rect.fromLTWH(w * 0.05, h * 0.15, w * 0.125, h * 0.31),
      Rect.fromLTWH(w * 0.20, h * 0.15, w * 0.10, h * 0.31),
      Rect.fromLTWH(w * 0.50, h * 0.15, w * 0.15, h * 0.31),
      Rect.fromLTWH(w * 0.70, h * 0.15, w * 0.075, h * 0.31),
      Rect.fromLTWH(w * 0.05, h * 0.65, w * 0.15, h * 0.27),
      Rect.fromLTWH(w * 0.50, h * 0.65, w * 0.125, h * 0.27),
    ];
    for (final b in blocks) {
      canvas.drawRect(b, blockFill);
      canvas.drawRect(b, blockLine);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GpsGrid extends StatelessWidget {
  const _GpsGrid();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _GpsItem(
                  label: 'Coordinates',
                  value: '2.9253°N, 101.6530°E',
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _GpsItem(
                  label: 'Geofence zone',
                  value: 'Garden Courtyard / Sector B',
                  soft: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _GpsItem(
                  label: 'GPS source',
                  value: 'NEO-6M · triggered on fall',
                  soft: true,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _GpsItem(label: 'Accuracy', value: '±2.4 m'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GpsItem extends StatelessWidget {
  final String label;
  final String value;
  final bool soft;
  const _GpsItem({required this.label, required this.value, this.soft = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppText.mono(size: 9.5, color: AppColors.inkFaint, ls: 0.57),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: soft
              ? AppText.mono(size: 12, color: AppColors.inkSoft)
              : AppText.mono(size: 12.5, weight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _StopwatchCard extends StatelessWidget {
  final IncidentController incident;
  const _StopwatchCard({required this.incident});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: incident,
      builder: (_, __) {
        final e = incident.active;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
          decoration: BoxDecoration(
            color: e ? AppColors.crimsonSoft : AppColors.surface,
            border: Border.all(color: e ? AppColors.crimson : AppColors.border),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Text(
                (e ? 'Time on floor · since detection' : 'Standing by · no active event')
                    .toUpperCase(),
                textAlign: TextAlign.center,
                style: AppText.mono(
                  size: 9.5,
                  color: e ? AppColors.crimson : AppColors.inkFaint,
                  weight: e ? FontWeight.w600 : FontWeight.w500,
                  ls: 0.95,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                incident.formatted,
                style: AppText.mono(
                  size: 44,
                  weight: FontWeight.w500,
                  color: e ? AppColors.crimson : AppColors.inkSoft,
                  ls: -1.3,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                e
                    ? 'Device buzzer: ACTIVE  ·  Caretaker paged'
                    : 'Last sync 12s ago  ·  Device buzzer: idle',
                textAlign: TextAlign.center,
                style: AppText.mono(size: 10.5, color: AppColors.inkSoft, ls: 0.2),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AckButton extends StatelessWidget {
  final IncidentController incident;
  const _AckButton({required this.incident});

  Future<void> _confirm(BuildContext context) async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => _ConfirmSheet(time: incident.formatted),
    );
    if (ok == true) incident.acknowledge();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: incident,
      builder: (context, _) => FilledButton(
        onPressed: incident.active ? () => _confirm(context) : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.crimson,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.inkFaint,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: const Text(
          'Acknowledge & reset',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _ConfirmSheet extends StatelessWidget {
  final String time;
  const _ConfirmSheet({required this.time});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.crimsonSoft,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.crimson,
                size: 22,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Confirm caretaker on site?',
              style: AppText.serif(size: 21, ls: -0.42, height: 1.2),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                style: AppText.sans(
                  size: 13.5,
                  color: AppColors.inkSoft,
                  height: 1.55,
                ),
                children: [
                  const TextSpan(text: 'This will log the total response time of '),
                  TextSpan(
                    text: time,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ' to the audit trail and silence the device buzzer. The patient\'s status will return to ',
                  ),
                  const TextSpan(
                    text: 'Normal · Standing',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.inkSoft,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.crimson,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Confirm reset',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EdgeAiCard extends StatelessWidget {
  final FallDetectionService service;
  const _EdgeAiCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Edge-AI live data',
      meta: 'dev',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<SensorReading>(
              stream: service.readings,
              builder: (_, s) {
                final r = s.data;
                return Text(
                  r == null
                      ? 'Waiting for sensor data...'
                      : 'Accel |a| ${r.accMagnitude.toStringAsFixed(2)} g   '
                          'Gyro ${r.gx.toStringAsFixed(1)}, '
                          '${r.gy.toStringAsFixed(1)}, ${r.gz.toStringAsFixed(1)}',
                  style: AppText.mono(size: 11, color: AppColors.inkSoft),
                );
              },
            ),
            const SizedBox(height: 6),
            StreamBuilder<double>(
              stream: service.modelProbability,
              builder: (_, s) {
                final p = s.data;
                return Text(
                  p == null
                      ? 'TFLite: warming up...'
                      : 'TFLite fall probability: ${(p * 100).toStringAsFixed(1)}%  (placeholder model)',
                  style: AppText.mono(size: 11, color: AppColors.inkSoft),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
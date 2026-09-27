import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';

class DeviceScreen extends StatelessWidget {
  final int batteryPct;
  const DeviceScreen({super.key, this.batteryPct = 78});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        const TabIntro(
          label: 'Hardware telemetry',
          text: 'Edge-AI bracelet · Firmware v2.3.1-edge',
        ),
        AppCard(
          title: 'Power cell',
          meta: 'TP4056 · 18650 Li-ion',
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
            child: Row(
              children: [
                SizedBox(
                  width: 64,
                  height: 130,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(painter: _BatteryPainter(batteryPct)),
                      ),
                      Text(
                        '$batteryPct%',
                        style: AppText.mono(size: 13, weight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Stat('Voltage', '3.92', unit: 'V'),
                      SizedBox(height: 11),
                      _Stat('Charge current', '0 mA', unit: ' · discharging'),
                      SizedBox(height: 11),
                      _Stat('Projected runtime', '118', unit: ' days remaining'),
                      SizedBox(height: 11),
                      _Stat('4-month target', 'on track', color: AppColors.emerald),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (batteryPct < 20) const _WarningBanner(),
        const AppCard(
          title: 'Connectivity & diagnostics',
          child: DividedColumn(
            children: [
              _DiagRow(label: 'BLE signal strength', value: '−67 dBm', leading: _SignalBars()),
              _DiagRow(label: 'Last sync ping', value: '14 s ago'),
              _DiagRow(
                label: 'Accelerometer (MPU-6050)',
                value: '● Operational',
                color: AppColors.emerald,
              ),
              _DiagRow(
                label: 'GPS module (NEO-6M)',
                value: '● 7 satellites locked',
                color: AppColors.emerald,
              ),
              _DiagRow(label: 'Fall threshold', value: '3.5 g · impact + 0.8s stillness'),
              _DiagRow(label: 'Edge-AI inference', value: 'TinyML · 24 ms latency'),
            ],
          ),
        ),
      ],
    );
  }
}

class _BatteryPainter extends CustomPainter {
  final int pct;
  const _BatteryPainter(this.pct);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 60, size.height / 130);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(22, 2, 16, 6),
        const Radius.circular(1),
      ),
      Paint()..color = AppColors.borderStrong,
    );

    final body = RRect.fromRectAndRadius(
      const Rect.fromLTWH(6, 8, 48, 120),
      const Radius.circular(3),
    );
    canvas.drawRRect(body, Paint()..color = Colors.white);
    canvas.drawRRect(
      body,
      Paint()
        ..color = AppColors.borderStrong
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final fillH = 116 * pct / 100;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(9, 125 - fillH, 42, fillH),
        const Radius.circular(1),
      ),
      Paint()..color = pct <= 20 ? AppColors.amber : AppColors.emerald,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BatteryPainter old) => old.pct != pct;
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final Color color;
  const _Stat(this.label, this.value, {this.unit, this.color = AppColors.ink});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppText.mono(size: 9.5, color: AppColors.inkFaint, ls: 0.57),
        ),
        const SizedBox(height: 2),
        Text.rich(
          TextSpan(
            text: value,
            style: AppText.mono(size: 14, weight: FontWeight.w500, color: color),
            children: [
              if (unit != null)
                TextSpan(
                  text: unit,
                  style: AppText.mono(size: 14, color: AppColors.inkFaint),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.amberSoft,
        border: Border.all(color: AppColors.amberBorder),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.amber, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: AppText.sans(
                  size: 11.5,
                  color: const Color(0xFF92400E),
                  height: 1.4,
                ),
                children: const [
                  TextSpan(
                    text: 'Cell below 20%.',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF78350F),
                    ),
                  ),
                  TextSpan(
                    text:
                        ' Automatic low-power alert dispatched to facility maintenance. '
                        'Replace or charge 18650 cell within 7 days.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Widget? leading;
  const _DiagRow({
    required this.label,
    required this.value,
    this.color = AppColors.ink,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: AppText.sans(size: 12, color: AppColors.inkSoft),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 6)],
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: AppText.mono(
                      size: 11.5,
                      weight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalBars extends StatelessWidget {
  const _SignalBars();

  @override
  Widget build(BuildContext context) {
    const heights = [4.0, 7.0, 10.0, 13.0];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < heights.length; i++)
          Container(
            width: 3,
            height: heights[i],
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              color: i == 3
                  ? AppColors.emerald.withValues(alpha: 0.3)
                  : AppColors.emerald,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
      ],
    );
  }
}
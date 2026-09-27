import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';

typedef _Incident = ({
  String date,
  String duration,
  String zone,
  String trigger,
  String who,
  String at,
});

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  static const _incidents = <_Incident>[
    (date: '14 Aug 2024 · 03:42', duration: '4m 18s floor', zone: 'Garden Courtyard / Sector B', trigger: '3.8 g impact · 0.9 s stillness', who: 'N. Syafiq', at: '03:46'),
    (date: '28 Jul 2024 · 19:15', duration: '2m 41s floor', zone: 'Corridor 2B', trigger: '3.6 g impact · 1.1 s stillness', who: 'M. Devi', at: '19:18'),
    (date: '12 Jul 2024 · 06:33', duration: '1m 52s floor', zone: 'Bedroom 14, Ward 2B', trigger: '3.5 g impact · 0.8 s stillness', who: 'N. Syafiq', at: '06:35'),
    (date: '03 Jul 2024 · 22:08', duration: '6m 04s floor', zone: 'Bathroom 2B · slip event', trigger: '4.1 g impact · 1.4 s stillness', who: 'M. Devi', at: '22:14'),
    (date: '19 May 2024 · 14:27', duration: '3m 27s floor', zone: 'Dining Hall · Sector A', trigger: '3.7 g impact · 0.9 s stillness', who: 'N. Syafiq', at: '14:30'),
    (date: '04 May 2024 · 11:50', duration: '2m 09s floor', zone: 'Garden Courtyard / Sector B', trigger: '3.5 g impact · 0.8 s stillness', who: 'M. Devi', at: '11:52'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: [
        const TabIntro(
          label: 'Incident history',
          text: '6 logged events · PT-2024-089',
        ),
        const _ChartCard(),
        AppCard(
          title: 'Audit log',
          meta: 'Verified · read-only',
          child: DividedColumn(
            padding: EdgeInsets.zero,
            children: [for (final e in _incidents) _IncidentItem(e)],
          ),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard();

  // (month, count, is current month)
  static const _bars = <(String, int, bool)>[
    ('May', 2, false),
    ('Jun', 0, false),
    ('Jul', 3, false),
    ('Aug', 1, true),
  ];

  @override
  Widget build(BuildContext context) {
    const maxCount = 5;
    return AppCard(
      title: 'Monthly fall incidents · 2024',
      meta: 'YTD: 6',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 160,
              child: Row(
                children: [
                  for (var i = 0; i < _bars.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(
                      child: _Bar(
                        label: _bars[i].$1,
                        count: _bars[i].$2,
                        fraction: _bars[i].$2 / maxCount,
                        current: _bars[i].$3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: const Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 4,
                children: [
                  _Summary('Avg response: ', '3m 21s'),
                  _Summary('Longest floor time: ', '6m 04s'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final int count;
  final double fraction;
  final bool current;
  const _Bar({
    required this.label,
    required this.count,
    required this.fraction,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: AppText.mono(
            size: 11,
            weight: FontWeight.w600,
            color: count == 0 ? AppColors.inkFaintest : AppColors.inkSoft,
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.bg,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(2),
            ),
            child: fraction > 0
                ? FractionallySizedBox(
                    heightFactor: fraction,
                    widthFactor: 1,
                    child: const ColoredBox(color: AppColors.crimson),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label.toUpperCase(),
          style: AppText.mono(
            size: 9.5,
            weight: current ? FontWeight.w600 : FontWeight.w400,
            color: current ? AppColors.crimson : AppColors.inkFaint,
            ls: 0.57,
          ),
        ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  final String label;
  final String value;
  const _Summary(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label,
        style: AppText.mono(size: 11, color: AppColors.inkSoft),
        children: [
          TextSpan(
            text: value,
            style: AppText.mono(size: 11, weight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _IncidentItem extends StatelessWidget {
  final _Incident e;
  const _IncidentItem(this.e);

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 60,
              child: Text(k, style: AppText.mono(size: 11, color: AppColors.inkFaint)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                v,
                style: AppText.mono(size: 11, color: AppColors.inkSoft, height: 1.5),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  e.date,
                  style: AppText.mono(size: 12, weight: FontWeight.w600, ls: -0.12),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.crimsonSoft,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  e.duration,
                  style: AppText.mono(
                    size: 10.5,
                    weight: FontWeight.w500,
                    color: AppColors.crimson,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _kv('GPS', '2.9253°N, 101.6530°E'),
          _kv('Zone', e.zone),
          _kv('Trigger', e.trigger),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Text(
                  'Responded by',
                  style: AppText.mono(size: 10.5, color: AppColors.inkFaint),
                ),
                const SizedBox(width: 6),
                Text(
                  e.who,
                  style: AppText.serif(
                    size: 12,
                    color: AppColors.inkSoft,
                    italic: true,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '· ${e.at}',
                  style: AppText.mono(size: 10.5, color: AppColors.inkFaint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
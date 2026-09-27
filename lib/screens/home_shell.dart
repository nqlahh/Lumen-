import 'package:flutter/material.dart';
import '../services/fall_detection_service.dart';
import '../state/incident_controller.dart';
import '../theme/app_theme.dart';
import 'device_screen.dart';
import 'logs_screen.dart';
import 'medical_screen.dart';
import 'monitor_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late final FallDetectionService _service;
  late final IncidentController _incident;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _service = FallDetectionService();
    _incident = IncidentController(_service);
    _service.start();
  }

  @override
  void dispose() {
    _incident.dispose();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _AppHeader(),
            _SimBar(incident: _incident),
            Expanded(
              child: IndexedStack(
                index: _index,
                children: [
                  MonitorScreen(service: _service, incident: _incident),
                  const MedicalScreen(),
                  const DeviceScreen(),
                  const LogsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(
        index: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cyberjaya Senior Care',
                  style: AppText.serif(size: 18, ls: -0.27, height: 1.1),
                ),
                const SizedBox(height: 2),
                Text(
                  'CARE COMPANION · RESPONDER',
                  style: AppText.mono(
                    size: 10,
                    color: AppColors.inkFaint,
                    ls: 0.6,
                  ),
                ),
              ],
            ),
          ),
          // TODO: show the real BLE connection state and RSSI
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.emeraldSoft,
              border: Border.all(color: AppColors.emeraldBorder),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: AppColors.emerald,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'ESP32 BLE · -67 dBm',
                  style: AppText.mono(
                    size: 10,
                    color: AppColors.emerald,
                    ls: 0.4,
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

class _SimBar extends StatelessWidget {
  final IncidentController incident;
  const _SimBar({required this.incident});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              const TextSpan(
                children: [
                  TextSpan(
                    text: '▸ ',
                    style: TextStyle(color: Color(0xFFF59E0B)),
                  ),
                  TextSpan(text: 'TEST HARNESS · EDGE-AI DEVICE'),
                ],
              ),
              style: AppText.mono(
                size: 9.5,
                color: const Color(0xFF64748B),
                ls: 0.76,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          ListenableBuilder(
            listenable: incident,
            builder: (_, __) {
              final active = incident.active;
              final color = active
                  ? const Color(0x66F1F5F9)
                  : const Color(0xFFF1F5F9);
              return OutlinedButton(
                onPressed: active ? null : incident.simulateFall,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF334155)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child: Text(
                  (active ? 'Fall event active' : 'Simulate fall event')
                      .toUpperCase(),
                  style: AppText.mono(size: 9.5, color: color, ls: 0.57),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.index, required this.onTap});

  static const _items = <(IconData, String)>[
    (Icons.home_outlined, 'Monitor'),
    (Icons.monitor_heart_outlined, 'Medical'),
    (Icons.battery_5_bar_outlined, 'Device'),
    (Icons.bar_chart, 'Logs'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: _NavItem(
                      icon: _items[i].$1,
                      label: _items[i].$2,
                      active: i == index,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final c = active ? AppColors.crimson : AppColors.inkFaint;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 2,
          color: active ? AppColors.crimson : Colors.transparent,
        ),
        const SizedBox(height: 8),
        Icon(icon, size: 21, color: c),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppText.sans(
            size: 9.5,
            weight: FontWeight.w500,
            color: c,
            ls: 0.19,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
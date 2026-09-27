import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';

class MedicalScreen extends StatelessWidget {
  const MedicalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      children: const [
        TabIntro(
          label: 'First responder records',
          text: 'Authorised clinical access · PT-2024-089',
        ),
        _VitalsCard(),
        _ConditionsCard(),
        _PrescriptionsCard(),
        _NotesCard(),
        _ContactsCard(),
      ],
    );
  }
}

class _VitalsCard extends StatelessWidget {
  const _VitalsCard();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      title: 'Critical vitals',
      meta: 'Updated 11 Aug',
      child: Padding(
        padding: EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _Vital('Blood type', 'O−', 'Universal donor · Rh-negative'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _Vital('Allergies', 'Penicillin', 'Severe · anaphylaxis'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _Vital('Weight', '54.2 kg', 'Last weighed 09 Aug'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _Vital('Mobility', 'Walker', "Post-hip fracture '21"),
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

class _Vital extends StatelessWidget {
  final String label;
  final String value;
  final String hint;
  const _Vital(this.label, this.value, this.hint);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppText.mono(size: 9.5, color: AppColors.inkFaint, ls: 0.57),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppText.mono(size: 18, weight: FontWeight.w500, ls: -0.36),
          ),
          const SizedBox(height: 2),
          Text(hint, style: AppText.mono(size: 10, color: AppColors.inkFaint)),
        ],
      ),
    );
  }
}

class _ConditionsCard extends StatelessWidget {
  const _ConditionsCard();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      title: 'Chronic conditions',
      child: DividedColumn(
        children: [
          _Condition('Hypertension', 'Diagnosed Mar 2019 · ICD-10 I10', 'Managed'),
          _Condition(
            'Osteoporosis',
            'Diagnosed Jul 2021 · T-score −3.1',
            'High risk',
            danger: true,
          ),
          _Condition(
            'Mild cognitive impairment',
            'Diagnosed Feb 2023 · MMSE 24/30',
            'Monitored',
          ),
        ],
      ),
    );
  }
}

class _Condition extends StatelessWidget {
  final String name;
  final String meta;
  final String severity;
  final bool danger;
  const _Condition(this.name, this.meta, this.severity, {this.danger = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppText.sans(size: 13, weight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(
                  meta,
                  style: AppText.mono(size: 10.5, color: AppColors.inkFaint),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: danger ? AppColors.crimsonSoft : AppColors.amberSoft,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              severity.toUpperCase(),
              style: AppText.mono(
                size: 9.5,
                color: danger ? AppColors.crimson : AppColors.amber,
                ls: 0.57,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrescriptionsCard extends StatelessWidget {
  const _PrescriptionsCard();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      title: 'Current prescriptions',
      child: DividedColumn(
        children: [
          _Rx('Amlodipine 5 mg', '1 × daily, morning · for hypertension'),
          _Rx('Alendronate 70 mg', '1 × weekly, morning fasting · for osteoporosis'),
          _Rx('Donepezil 5 mg', '1 × daily, evening · for MCI'),
          _Rx('Calcium + Vitamin D', '2 × daily, with meals'),
        ],
      ),
    );
  }
}

class _Rx extends StatelessWidget {
  final String name;
  final String dose;
  const _Rx(this.name, this.dose);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppText.sans(size: 13, weight: FontWeight.w500)),
          const SizedBox(height: 3),
          Text(dose, style: AppText.mono(size: 11.5, color: AppColors.inkSoft)),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard();

  @override
  Widget build(BuildContext context) {
    final bold = AppText.sans(
      size: 12.5,
      weight: FontWeight.w600,
      color: AppColors.ink,
    );
    return AppCard(
      title: 'Physician notes',
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                style: AppText.sans(
                  size: 12.5,
                  color: AppColors.inkSoft,
                  height: 1.55,
                  italic: true,
                ),
                children: [
                  TextSpan(
                    text: 'Elevated fall risk.',
                    style: bold.copyWith(fontStyle: FontStyle.normal),
                  ),
                  const TextSpan(
                    text:
                        ' Recent unsteadiness reported by ward staff during evening transfers. '
                        'Right hip vulnerable post-2021 fracture — handle with care during assisted lift. '
                        'Patient responds well to verbal reassurance; ',
                  ),
                  TextSpan(
                    text: 'avoid sudden movements',
                    style: bold.copyWith(fontStyle: FontStyle.normal),
                  ),
                  const TextSpan(text: ' during assistance.'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '— Dr. Siti Aminah, Geriatric Care · 09 Aug 2024',
              style: AppText.mono(size: 10, color: AppColors.inkFaint, ls: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactsCard extends StatelessWidget {
  const _ContactsCard();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      title: 'Emergency contacts',
      child: DividedColumn(
        children: [
          _Contact('Ahmad Rahman', 'Son · Primary · +60 12-345 6789'),
          _Contact('Nurul Rahman', 'Daughter · Secondary · +60 12-987 6543'),
          _Contact('Dr. Siti Aminah', 'Geriatrician · Cyberjaya SC · +60 3-8312 4455'),
        ],
      ),
    );
  }
}

class _Contact extends StatelessWidget {
  final String name;
  final String relation;
  const _Contact(this.name, this.relation);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppText.sans(size: 13, weight: FontWeight.w500)),
                const SizedBox(height: 1),
                Text(
                  relation,
                  style: AppText.mono(size: 10.5, color: AppColors.inkFaint),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: AppColors.emeraldSoft,
            shape: const CircleBorder(
              side: BorderSide(color: AppColors.emeraldBorder),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              // TODO: dial the number with url_launcher (tel:)
              onTap: () {},
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(Icons.phone_outlined, size: 18, color: AppColors.emerald),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
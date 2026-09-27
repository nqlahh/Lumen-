import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final String? title;
  final String? meta;
  final Widget child;

  const AppCard({super.key, this.title, this.meta, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 11, 14, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title!.toUpperCase(),
                      style: AppText.mono(
                        size: 10,
                        color: AppColors.inkFaint,
                        weight: FontWeight.w500,
                        ls: 1.0,
                      ),
                    ),
                  ),
                  if (meta != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      meta!,
                      style: AppText.mono(
                        size: 10,
                        color: AppColors.inkFaint,
                        ls: 0.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          child,
        ],
      ),
    );
  }
}

class TabIntro extends StatelessWidget {
  final String label;
  final String text;

  const TabIntro({super.key, required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 4, 2, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppText.mono(size: 10, color: AppColors.inkFaint, ls: 0.6),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: AppText.mono(
              size: 11.5,
              color: AppColors.inkSoft,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class DividedColumn extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;

  const DividedColumn({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(14, 0, 14, 14),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              const Divider(height: 1, thickness: 1, color: AppColors.border),
            children[i],
          ],
        ],
      ),
    );
  }
}
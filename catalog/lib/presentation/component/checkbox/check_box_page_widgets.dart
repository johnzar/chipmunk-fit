import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';

class CheckBoxSectionCard extends StatelessWidget {
  const CheckBoxSectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.child,
  });

  final String title;
  final String description;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.backgroundElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.dividerPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colors.main, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: context.subtitle4().copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: context.caption1().copyWith(color: colors.textTertiary),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class CheckBoxValueBadge extends StatelessWidget {
  const CheckBoxValueBadge({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.main.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: context.caption1().copyWith(
              color: colors.main,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
      ),
    );
  }
}

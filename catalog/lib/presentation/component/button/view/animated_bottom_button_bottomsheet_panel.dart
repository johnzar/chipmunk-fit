import 'package:chip_component/button/fit_button.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';

class AnimatedBottomButtonBottomSheetPanel extends StatelessWidget {
  const AnimatedBottomButtonBottomSheetPanel({
    super.key,
    required this.onShowBasic,
    required this.onShowOverflow,
    required this.onShowMultiple,
  });

  final VoidCallback onShowBasic;
  final VoidCallback onShowOverflow;
  final VoidCallback onShowMultiple;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'BottomSheet Test',
      child: Column(
        children: [
          _PresetButton(
            label: 'Basic + TextField',
            onPressed: onShowBasic,
          ),
          const SizedBox(height: 8),
          _PresetButton(
            label: 'Overflow Scroll + TextField',
            onPressed: onShowOverflow,
          ),
          const SizedBox(height: 8),
          _PresetButton(
            label: 'Multiple TextFields',
            onPressed: onShowMultiple,
          ),
        ],
      ),
    );
  }
}

class _PresetButton extends StatelessWidget {
  const _PresetButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FitButton(
      isExpanded: true,
      type: FitButtonType.secondary,
      onPressed: onPressed,
      child: Text(
        label,
        style: context.button1(),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.backgroundElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.dividerPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.subtitle4().copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

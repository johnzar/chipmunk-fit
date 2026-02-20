import 'package:chip_component/button/fit_button.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';

class ButtonPreviewPanel extends StatelessWidget {
  const ButtonPreviewPanel({
    super.key,
    required this.buttonText,
    required this.maxLines,
    required this.selectedType,
    required this.isEnabled,
    required this.isLoading,
    required this.isExpanded,
    required this.enableRipple,
    required this.onPressed,
    required this.onDisabledPressed,
  });

  final String buttonText;
  final int maxLines;
  final FitButtonType selectedType;
  final bool isEnabled;
  final bool isLoading;
  final bool isExpanded;
  final bool enableRipple;
  final VoidCallback onPressed;
  final VoidCallback onDisabledPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return _SectionCard(
      title: 'Playground',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FitButton(
            type: selectedType,
            maxLines: maxLines,
            isEnabled: isEnabled,
            isLoading: isLoading,
            isExpanded: isExpanded,
            enableRipple: enableRipple,
            onPressed: onPressed,
            onDisabledPressed: onDisabledPressed,
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: context.button1(),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '로딩 중 탭은 무시되며, Disabled 상태에서만 onDisabledPressed가 동작합니다.',
            style: context.caption1().copyWith(color: colors.textTertiary),
          ),
        ],
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

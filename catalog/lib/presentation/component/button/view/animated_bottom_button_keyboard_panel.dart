import 'package:chip_component/chip/fit_chip.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';

class AnimatedBottomButtonKeyboardPanel extends StatelessWidget {
  const AnimatedBottomButtonKeyboardPanel({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onRequestFocus,
    required this.onClearFocus,
    required this.isFocused,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onRequestFocus;
  final VoidCallback onClearFocus;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return _SectionCard(
      title: 'Keyboard Test',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            style: context.body3().copyWith(color: colors.textPrimary),
            decoration: InputDecoration(
              hintText: '입력 후 키보드 열기/닫기 테스트',
              hintStyle: context.body4().copyWith(color: colors.textTertiary),
              filled: true,
              fillColor: colors.backgroundBase,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.dividerPrimary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.main),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              FitChip(
                isSelected: isFocused,
                onTap: onRequestFocus,
                backgroundColor: colors.backgroundBase,
                selectedBackgroundColor: colors.main.withValues(alpha: 0.14),
                borderColor: colors.dividerPrimary,
                selectedBorderColor: colors.main,
                borderRadius: 12,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  'Focus',
                  style: context.caption1().copyWith(
                        color: isFocused ? colors.main : colors.textSecondary,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              FitChip(
                isSelected: !isFocused,
                onTap: onClearFocus,
                backgroundColor: colors.backgroundBase,
                selectedBackgroundColor: colors.main.withValues(alpha: 0.14),
                borderColor: colors.dividerPrimary,
                selectedBorderColor: colors.main,
                borderRadius: 12,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  'Dismiss',
                  style: context.caption1().copyWith(
                        color: !isFocused ? colors.main : colors.textSecondary,
                      ),
                ),
              ),
            ],
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

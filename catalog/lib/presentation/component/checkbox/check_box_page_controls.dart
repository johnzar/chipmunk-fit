import 'package:chip_component/checkbox/fit_checkbox_style.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';

import 'check_box_page_widgets.dart';

class CheckBoxPageControls extends StatelessWidget {
  const CheckBoxPageControls({
    super.key,
    required this.selectedStyle,
    required this.onStyleChanged,
    required this.size,
    required this.onSizeChanged,
    required this.borderWidth,
    required this.onBorderWidthChanged,
  });

  final FitCheckboxStyle selectedStyle;
  final ValueChanged<FitCheckboxStyle> onStyleChanged;
  final double size;
  final ValueChanged<double> onSizeChanged;
  final double borderWidth;
  final ValueChanged<double> onBorderWidthChanged;

  @override
  Widget build(BuildContext context) {
    return CheckBoxSectionCard(
      title: 'Global Settings',
      description: 'style / size / border',
      icon: Icons.tune,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final style in FitCheckboxStyle.values)
                ChoiceChip(
                  label: Text(
                    style.name,
                    style: context.caption1().copyWith(
                          color: selectedStyle == style
                              ? Colors.white
                              : context.fitColors.textSecondary,
                        ),
                  ),
                  selected: selectedStyle == style,
                  onSelected: (selected) {
                    if (selected) onStyleChanged(style);
                  },
                  selectedColor: context.fitColors.main,
                  backgroundColor: context.fitColors.backgroundBase,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: selectedStyle == style
                          ? context.fitColors.main
                          : context.fitColors.dividerPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SliderField(
                  title: 'Size',
                  valueLabel: '${size.toStringAsFixed(0)}px',
                  value: size,
                  min: 16,
                  max: 40,
                  divisions: 16,
                  onChanged: onSizeChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SliderField(
                  title: 'Border',
                  valueLabel: borderWidth.toStringAsFixed(1),
                  value: borderWidth,
                  min: 1.0,
                  max: 2.4,
                  divisions: 14,
                  onChanged: onBorderWidthChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliderField extends StatelessWidget {
  const _SliderField({
    required this.title,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String title;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.caption1().copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            CheckBoxValueBadge(label: valueLabel),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: colors.main,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

import 'package:chip_component/checkbox/fit_checkbox.dart';
import 'package:chip_component/checkbox/fit_checkbox_style.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';

import 'check_box_page_widgets.dart';

class CheckBoxPageSections extends StatelessWidget {
  const CheckBoxPageSections({
    super.key,
    required this.style,
    required this.size,
    required this.borderWidth,
    required this.basicChecked,
    required this.onBasicChanged,
    required this.labelLeftChecked,
    required this.onLabelLeftChanged,
    required this.errorChecked,
    required this.onErrorChanged,
    required this.disabledChecked,
  });

  final FitCheckboxStyle style;
  final double size;
  final double borderWidth;
  final bool basicChecked;
  final ValueChanged<bool> onBasicChanged;
  final bool labelLeftChecked;
  final ValueChanged<bool> onLabelLeftChanged;
  final bool errorChecked;
  final ValueChanged<bool> onErrorChanged;
  final bool disabledChecked;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBasicSection(context),
        const SizedBox(height: 16),
        _buildStateSection(context),
        const SizedBox(height: 16),
        _buildStyleSection(context),
        const SizedBox(height: 16),
        _buildSizeSection(context),
      ],
    );
  }

  Widget _buildBasicSection(BuildContext context) {
    final colors = context.fitColors;
    return CheckBoxSectionCard(
      title: 'Basic',
      description: '핵심 동작 확인',
      icon: Icons.check_box_outlined,
      child: Column(
        children: [
          FitCheckbox(
            value: basicChecked,
            onChanged: onBasicChanged,
            style: style,
            size: size,
            borderWidth: borderWidth,
          ),
          const SizedBox(height: 8),
          Text(
            basicChecked ? 'Checked' : 'Unchecked',
            style: context
                .caption1()
                .copyWith(color: colors.textTertiary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildStateSection(BuildContext context) {
    final colors = context.fitColors;
    return CheckBoxSectionCard(
      title: 'States',
      description: 'label-left / disabled / error',
      icon: Icons.tune,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FitCheckbox(
            value: labelLeftChecked,
            onChanged: onLabelLeftChanged,
            style: style,
            size: size,
            borderWidth: borderWidth,
            label: '라벨이 왼쪽에 위치',
            labelOnLeft: true,
            labelStyle: context.body3().copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 10),
          FitCheckbox(
            value: disabledChecked,
            onChanged: null,
            style: style,
            size: size,
            borderWidth: borderWidth,
            label: '비활성화 상태 체크박스',
            labelStyle: context.body3().copyWith(color: colors.textDisabled),
          ),
          const SizedBox(height: 10),
          FitCheckbox(
            value: errorChecked,
            onChanged: onErrorChanged,
            style: style,
            size: size,
            borderWidth: borderWidth,
            hasError: true,
            label: '에러 상태 체크박스',
            labelStyle: context
                .body3()
                .copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleSection(BuildContext context) {
    return CheckBoxSectionCard(
      title: 'Style',
      description: 'material / rounded / outlined',
      icon: Icons.palette_outlined,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StylePreview(
            style: FitCheckboxStyle.material,
            label: 'Material',
            size: 24,
            borderWidth: borderWidth,
          ),
          _StylePreview(
            style: FitCheckboxStyle.rounded,
            label: 'Rounded',
            size: 24,
            borderWidth: borderWidth,
          ),
          _StylePreview(
            style: FitCheckboxStyle.outlined,
            label: 'Outlined',
            size: 24,
            borderWidth: borderWidth,
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSection(BuildContext context) {
    return CheckBoxSectionCard(
      title: 'Size',
      description: 'Small / Medium / Large',
      icon: Icons.format_size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _SizePreview(
            style: style,
            borderWidth: borderWidth,
            size: 18,
            label: 'S',
          ),
          _SizePreview(
            style: style,
            borderWidth: borderWidth,
            size: 24,
            label: 'M',
          ),
          _SizePreview(
            style: style,
            borderWidth: borderWidth,
            size: 30,
            label: 'L',
          ),
        ],
      ),
    );
  }
}

class _StylePreview extends StatelessWidget {
  const _StylePreview({
    required this.style,
    required this.label,
    required this.size,
    required this.borderWidth,
  });

  final FitCheckboxStyle style;
  final String label;
  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;
    return Column(
      children: [
        FitCheckbox(
          value: true,
          onChanged: (_) {},
          style: style,
          size: size,
          borderWidth: borderWidth,
          activeColor: colors.main,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: context.caption1().copyWith(color: colors.textTertiary),
        ),
      ],
    );
  }
}

class _SizePreview extends StatelessWidget {
  const _SizePreview({
    required this.style,
    required this.size,
    required this.label,
    required this.borderWidth,
  });

  final FitCheckboxStyle style;
  final double size;
  final String label;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;
    return Column(
      children: [
        FitCheckbox(
          value: true,
          onChanged: (_) {},
          style: style,
          size: size,
          borderWidth: borderWidth,
          activeColor: colors.main,
        ),
        const SizedBox(height: 8),
        Text(
          '$label (${size.toInt()})',
          style: context.caption1().copyWith(color: colors.textTertiary),
        ),
      ],
    );
  }
}

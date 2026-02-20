import 'package:catalog/presentation/component/button/model/button_catalog_models.dart';
import 'package:chip_component/chip/fit_chip.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:flutter/material.dart';

class ButtonControlPanel extends StatelessWidget {
  const ButtonControlPanel({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    required this.maxLines,
    required this.onMaxLinesChanged,
    required this.isEnabled,
    required this.onEnabledChanged,
    required this.isLoading,
    required this.onLoadingChanged,
    required this.isExpanded,
    required this.onExpandedChanged,
    required this.enableRipple,
    required this.onRippleChanged,
    required this.textController,
  });

  final FitButtonType selectedType;
  final ValueChanged<FitButtonType> onTypeSelected;
  final int maxLines;
  final ValueChanged<int> onMaxLinesChanged;
  final bool isEnabled;
  final ValueChanged<bool> onEnabledChanged;
  final bool isLoading;
  final ValueChanged<bool> onLoadingChanged;
  final bool isExpanded;
  final ValueChanged<bool> onExpandedChanged;
  final bool enableRipple;
  final ValueChanged<bool> onRippleChanged;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ControlCard(
          title: 'Controls',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypeSelector(context),
              const SizedBox(height: 16),
              _buildMaxLinesSelector(context),
              const SizedBox(height: 16),
              _buildSwitchRows(context),
              const SizedBox(height: 16),
              _buildTextField(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type',
          style: context.subtitle5().copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: buttonTypeMetas.map((meta) {
            final selected = meta.type == selectedType;
            return FitChip(
              isSelected: selected,
              onTap: () => onTypeSelected(meta.type),
              backgroundColor: colors.backgroundBase,
              selectedBackgroundColor: colors.main.withValues(alpha: 0.14),
              borderColor: colors.dividerPrimary,
              selectedBorderColor: colors.main,
              borderRadius: 12,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                meta.label,
                style: context.caption1().copyWith(
                      color: selected ? colors.main : colors.textSecondary,
                    ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMaxLinesSelector(BuildContext context) {
    final colors = context.fitColors;
    const options = [1, 2, 3];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Max Lines',
          style: context.subtitle5().copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 8),
        Row(
          children: options.map((line) {
            final selected = maxLines == line;
            return Padding(
              padding: EdgeInsets.only(right: line == options.last ? 0 : 8),
              child: FitChip(
                isSelected: selected,
                onTap: () => onMaxLinesChanged(line),
                backgroundColor: colors.backgroundBase,
                selectedBackgroundColor: colors.main.withValues(alpha: 0.14),
                borderColor: colors.dividerPrimary,
                selectedBorderColor: colors.main,
                borderRadius: 12,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  '$line',
                  style: context.caption1().copyWith(
                        color: selected ? colors.main : colors.textSecondary,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSwitchRows(BuildContext context) {
    return Column(
      children: [
        _SwitchRow(
          title: 'Enabled',
          techKey: 'isEnabled',
          value: isEnabled,
          onChanged: onEnabledChanged,
        ),
        _SwitchRow(
          title: 'Loading',
          techKey: 'isLoading',
          value: isLoading,
          onChanged: onLoadingChanged,
        ),
        _SwitchRow(
          title: 'Expanded',
          techKey: 'isExpanded',
          value: isExpanded,
          onChanged: onExpandedChanged,
        ),
        _SwitchRow(
          title: 'Ripple',
          techKey: 'enableRipple',
          value: enableRipple,
          onChanged: onRippleChanged,
        ),
      ],
    );
  }

  Widget _buildTextField(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Label',
          style: context.subtitle5().copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          style: context.body3().copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: '버튼 라벨을 입력하세요',
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
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            isDense: true,
          ),
        ),
      ],
    );
  }
}

class _ControlCard extends StatelessWidget {
  const _ControlCard({
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

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.techKey,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String techKey;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.backgroundBase,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.dividerPrimary),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.body3().copyWith(color: colors.textPrimary),
                ),
                Text(
                  techKey,
                  style:
                      context.caption1().copyWith(color: colors.textTertiary),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: colors.main,
            activeTrackColor: colors.main.withValues(alpha: 0.32),
          ),
        ],
      ),
    );
  }
}

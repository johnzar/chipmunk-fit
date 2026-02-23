import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:chip_component/radio/fit_radio_button.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';

class RadioButtonPage extends StatefulWidget {
  const RadioButtonPage({super.key});

  @override
  State<RadioButtonPage> createState() => _RadioButtonPageState();
}

class _RadioButtonPageState extends State<RadioButtonPage> {
  double _size = 22.0;

  String? _basicSelected = 'option1';
  String? _labelSelected = 'medium';
  String? _errorSelected;
  final String _disabledSelected = 'disabled1';
  String? _surveySelected = 'coffee';

  @override
  Widget build(BuildContext context) {
    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: 'FitRadioButton',
        actions: const [CatalogThemeSwitcher(), SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: [
            _SettingsCard(
              size: _size,
              onSizeChanged: (value) => setState(() => _size = value),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Basic',
              description: '단일 선택 그룹 기본 동작',
              icon: Icons.radio_button_checked,
              child: Column(
                children: [
                  _OptionRow(
                    title: '옵션 1',
                    subtitle: '기본 선택 옵션',
                    selected: _basicSelected == 'option1',
                    onTap: () => setState(() => _basicSelected = 'option1'),
                    leading: FitRadioButton<String>(
                      value: 'option1',
                      groupValue: _basicSelected,
                      onChanged: (value) =>
                          setState(() => _basicSelected = value),
                      size: _size,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _OptionRow(
                    title: '옵션 2',
                    subtitle: '비교 선택 옵션',
                    selected: _basicSelected == 'option2',
                    onTap: () => setState(() => _basicSelected = 'option2'),
                    leading: FitRadioButton<String>(
                      value: 'option2',
                      groupValue: _basicSelected,
                      onChanged: (value) =>
                          setState(() => _basicSelected = value),
                      size: _size,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _OptionRow(
                    title: '옵션 3',
                    subtitle: '세 번째 선택 옵션',
                    selected: _basicSelected == 'option3',
                    onTap: () => setState(() => _basicSelected = 'option3'),
                    leading: FitRadioButton<String>(
                      value: 'option3',
                      groupValue: _basicSelected,
                      onChanged: (value) =>
                          setState(() => _basicSelected = value),
                      size: _size,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'States',
              description: 'label-left / disabled / error',
              icon: Icons.tune,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FitRadioButton<String>(
                    value: 'small',
                    groupValue: _labelSelected,
                    onChanged: (value) =>
                        setState(() => _labelSelected = value),
                    size: _size,
                    label: '라벨 좌측 배치',
                    labelOnLeft: true,
                    labelStyle: context.body3().copyWith(
                          color: context.fitColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  FitRadioButton<String>(
                    value: 'disabled1',
                    groupValue: _disabledSelected,
                    onChanged: null,
                    size: _size,
                    label: '비활성화 (선택됨)',
                    labelStyle: context.body3().copyWith(
                          color: context.fitColors.textDisabled,
                        ),
                  ),
                  const SizedBox(height: 10),
                  FitRadioButton<String>(
                    value: 'disabled2',
                    groupValue: _disabledSelected,
                    onChanged: null,
                    size: _size,
                    label: '비활성화 (미선택)',
                    labelStyle: context.body3().copyWith(
                          color: context.fitColors.textDisabled,
                        ),
                  ),
                  const SizedBox(height: 10),
                  FitRadioButton<String>(
                    value: 'error1',
                    groupValue: _errorSelected,
                    onChanged: (value) =>
                        setState(() => _errorSelected = value),
                    size: _size,
                    hasError: true,
                    label: '에러 상태 옵션',
                    labelStyle: context.body3().copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Survey Example',
              description: '카드형 선택 UI',
              icon: Icons.poll_outlined,
              child: Column(
                children: [
                  _SurveyOption(
                    title: '☕ 커피',
                    subtitle: '진한 향과 쓴맛의 매력',
                    value: 'coffee',
                    selectedValue: _surveySelected,
                    size: _size,
                    onChanged: (value) =>
                        setState(() => _surveySelected = value),
                  ),
                  const SizedBox(height: 10),
                  _SurveyOption(
                    title: '🍵 차',
                    subtitle: '은은한 향과 부드러운 맛',
                    value: 'tea',
                    selectedValue: _surveySelected,
                    size: _size,
                    onChanged: (value) =>
                        setState(() => _surveySelected = value),
                  ),
                  const SizedBox(height: 10),
                  _SurveyOption(
                    title: '🧃 주스',
                    subtitle: '상큼하고 달콤한 과일의 맛',
                    value: 'juice',
                    selectedValue: _surveySelected,
                    size: _size,
                    onChanged: (value) =>
                        setState(() => _surveySelected = value),
                  ),
                  const SizedBox(height: 10),
                  _SurveyOption(
                    title: '💧 물',
                    subtitle: '깔끔하고 건강한 선택',
                    value: 'water',
                    selectedValue: _surveySelected,
                    size: _size,
                    onChanged: (value) =>
                        setState(() => _surveySelected = value),
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

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.size,
    required this.onSizeChanged,
  });

  final double size;
  final ValueChanged<double> onSizeChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return _SectionCard(
      title: 'Global Settings',
      description: 'material 단일 타입 / 크기 설정',
      icon: Icons.tune,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Size',
                style: context.caption1().copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              _ValueBadge(label: '${size.toStringAsFixed(0)}px'),
            ],
          ),
          Slider(
            value: size,
            min: 16,
            max: 34,
            divisions: 18,
            activeColor: colors.main,
            onChanged: onSizeChanged,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.dividerPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colors.main, size: 18),
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

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.leading,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? colors.main.withValues(alpha: 0.08)
              : colors.backgroundBase,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? colors.main : colors.dividerPrimary,
          ),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.body3().copyWith(color: colors.textPrimary),
                  ),
                  Text(
                    subtitle,
                    style:
                        context.caption1().copyWith(color: colors.textTertiary),
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

class _SurveyOption extends StatelessWidget {
  const _SurveyOption({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.selectedValue,
    required this.size,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final String value;
  final String? selectedValue;
  final double size;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;
    final isSelected = selectedValue == value;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChanged(value),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.main.withValues(alpha: 0.08)
              : colors.backgroundBase,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.main : colors.dividerPrimary,
          ),
        ),
        child: Row(
          children: [
            FitRadioButton<String>(
              value: value,
              groupValue: selectedValue,
              onChanged: onChanged,
              size: size,
              activeColor: colors.main,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.body3().copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    subtitle,
                    style:
                        context.caption1().copyWith(color: colors.textTertiary),
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

class _ValueBadge extends StatelessWidget {
  const _ValueBadge({required this.label});

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

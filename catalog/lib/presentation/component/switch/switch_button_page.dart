import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:chip_component/button/fit_switch_button.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';

class SwitchButtonPage extends StatefulWidget {
  const SwitchButtonPage({super.key});

  @override
  State<SwitchButtonPage> createState() => _SwitchButtonPageState();
}

class _SwitchButtonPageState extends State<SwitchButtonPage> {
  bool _basicOn = false;
  bool _coloredOn = true;
  final bool _disabledOn = true;
  int _debounceMs = 300;
  bool? _lastValue;

  Duration get _debounceDuration => Duration(milliseconds: _debounceMs);

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: 'FitSwitchButton',
        actions: const [CatalogThemeSwitcher(), SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: [
            _SectionCard(
              title: 'Global Settings',
              description: 'debounce 제어',
              icon: Icons.tune,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Debounce',
                    style: context.caption1().copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [0, 300, 600].map((ms) {
                      final selected = _debounceMs == ms;
                      return ChoiceChip(
                        label: Text('${ms}ms'),
                        selected: selected,
                        onSelected: (_) => setState(() => _debounceMs = ms),
                        selectedColor: colors.main,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.backgroundBase,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.dividerPrimary),
                    ),
                    child: Text(
                      'lastValue: ${_lastValue?.toString() ?? '-'}',
                      style:
                          context.body3().copyWith(color: colors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Scenarios',
              description: 'basic / disabled / custom-color',
              icon: Icons.toggle_on_outlined,
              child: Column(
                children: [
                  _SwitchRow(
                    label: 'Basic',
                    description: 'adaptive 기본 스타일',
                    child: FitSwitchButton(
                      isOn: _basicOn,
                      debounceDuration: _debounceDuration,
                      onToggle: (next) {
                        setState(() {
                          _basicOn = next;
                          _lastValue = next;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SwitchRow(
                    label: 'Disabled',
                    description: '입력 비활성 상태',
                    child: AbsorbPointer(
                      child: FitSwitchButton(
                        isOn: _disabledOn,
                        debounceDuration: _debounceDuration,
                        onToggle: (_) {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SwitchRow(
                    label: 'Custom Color',
                    description: 'active/inactive 트랙 색상 오버라이드',
                    child: FitSwitchButton(
                      isOn: _coloredOn,
                      debounceDuration: _debounceDuration,
                      activeColor: colors.main,
                      inactiveColor: colors.grey300,
                      onToggle: (next) {
                        setState(() {
                          _coloredOn = next;
                          _lastValue = next;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Current Value',
              description: '상태 확인',
              icon: Icons.info_outline,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StateChip(label: 'Basic', value: _basicOn),
                  _StateChip(label: 'Custom', value: _coloredOn),
                  _StateChip(label: 'Disabled', value: _disabledOn),
                ],
              ),
            ),
          ],
        ),
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

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.description,
    required this.child,
  });

  final String label;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Container(
      width: double.infinity,
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
                  label,
                  style: context.body3().copyWith(color: colors.textPrimary),
                ),
                Text(
                  description,
                  style:
                      context.caption1().copyWith(color: colors.textTertiary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          child,
        ],
      ),
    );
  }
}

class _StateChip extends StatelessWidget {
  const _StateChip({required this.label, required this.value});

  final String label;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.backgroundBase,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.dividerPrimary),
      ),
      child: Text(
        '$label: ${value ? 'ON' : 'OFF'}',
        style: context.caption1().copyWith(color: colors.textSecondary),
      ),
    );
  }
}

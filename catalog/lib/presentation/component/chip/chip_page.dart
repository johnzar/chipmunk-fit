import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:chip_component/chip/fit_chip.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_foundation/textstyle.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';

/// FitChip 테스트 페이지
class ChipPage extends StatefulWidget {
  const ChipPage({super.key});

  @override
  State<ChipPage> createState() => _ChipPageState();
}

class _ChipPageState extends State<ChipPage> {
  bool _isEnabled = true;
  bool _motionSelected = false;

  String _selectedSize = 'M';
  final Set<String> _selectedFilters = {'전체'};
  final List<String> _tags = ['Flutter', 'Design', 'iOS'];

  static const _sizes = ['XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL'];
  static const _filters = [
    '전체',
    '디자인',
    '개발',
    '마케팅',
    '기획',
    '프론트엔드',
    '백엔드',
    'iOS',
    'Android',
    'Flutter',
  ];

  @override
  Widget build(BuildContext context) {
    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: 'FitChip',
        actions: const [CatalogThemeSwitcher(), SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: [
            _SectionCard(
              title: 'Global Settings',
              description: '테스트 입력 활성화',
              icon: Icons.tune,
              child: Row(
                children: [
                  Text(
                    'Enabled',
                    style: context.body3().copyWith(
                          color: context.fitColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  Switch.adaptive(
                    value: _isEnabled,
                    onChanged: (value) => setState(() => _isEnabled = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Motion Preview',
              description: 'FitButton과 동일한 press/release 모션',
              icon: Icons.touch_app_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FitChip(
                    isEnabled: _isEnabled,
                    isSelected: _motionSelected,
                    onSelected: (next) =>
                        setState(() => _motionSelected = next),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    borderRadius: 20,
                    selectedBackgroundColor:
                        context.fitColors.main.withValues(alpha: 0.12),
                    selectedBorderColor: context.fitColors.main,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _motionSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color: _motionSelected
                              ? context.fitColors.main
                              : context.fitColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _motionSelected ? '선택됨' : '탭해서 선택',
                          style: context.body3().copyWith(
                                color: context.fitColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '빠른 탭에서도 눌림 모션이 보이도록 최소 프레스 표시 시간을 적용했습니다.',
                    style: context
                        .caption1()
                        .copyWith(color: context.fitColors.textTertiary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Choice',
              description: '단일 선택 칩',
              icon: Icons.radio_button_checked,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _sizes.map((size) {
                  final isSelected = _selectedSize == size;
                  return FitChip(
                    isEnabled: _isEnabled,
                    isSelected: isSelected,
                    onSelected: (_) => setState(() => _selectedSize = size),
                    backgroundColor: context.fitColors.backgroundBase,
                    selectedBackgroundColor: context.fitColors.main,
                    selectedBorderColor: context.fitColors.main,
                    borderColor: context.fitColors.dividerPrimary,
                    child: Text(
                      size,
                      style: context.body3().copyWith(
                            color: isSelected
                                ? Colors.white
                                : context.fitColors.textPrimary,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Filter',
              description: '다중 선택 칩',
              icon: Icons.filter_list,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _filters.map((filter) {
                      final isSelected = _selectedFilters.contains(filter);
                      return FitChip(
                        isEnabled: _isEnabled,
                        isSelected: isSelected,
                        onSelected: (_) => _toggleFilter(filter),
                        backgroundColor: context.fitColors.backgroundBase,
                        selectedBackgroundColor:
                            context.fitColors.main.withValues(alpha: 0.1),
                        selectedBorderColor: context.fitColors.main,
                        borderColor: context.fitColors.dividerPrimary,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) ...[
                              Icon(
                                Icons.check,
                                size: 14,
                                color: context.fitColors.main,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              filter,
                              style: context.body3().copyWith(
                                    color: isSelected
                                        ? context.fitColors.main
                                        : context.fitColors.textPrimary,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '선택됨: ${_selectedFilters.join(', ')}',
                    style: context
                        .caption1()
                        .copyWith(color: context.fitColors.textTertiary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Input',
              description: '태그 입력/삭제',
              icon: Icons.tag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._tags.map((tag) {
                        return FitChip(
                          isEnabled: _isEnabled,
                          backgroundColor: context.fitColors.backgroundBase,
                          borderColor: context.fitColors.dividerPrimary,
                          onTap: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tag,
                                style: context.body3().copyWith(
                                      color: context.fitColors.textPrimary,
                                    ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: _isEnabled
                                    ? () => setState(() => _tags.remove(tag))
                                    : null,
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: context.fitColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      FitChip(
                        isEnabled: _isEnabled,
                        backgroundColor:
                            context.fitColors.main.withValues(alpha: 0.1),
                        borderColor: context.fitColors.main,
                        onTap: _addTag,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              size: 14,
                              color: context.fitColors.main,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '추가',
                              style: context.body3().copyWith(
                                    color: context.fitColors.main,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFilter(String value) {
    if (!_isEnabled) return;

    setState(() {
      if (_selectedFilters.contains(value)) {
        _selectedFilters.remove(value);
      } else {
        _selectedFilters.add(value);
      }

      if (_selectedFilters.isEmpty) {
        _selectedFilters.add('전체');
      }
    });
  }

  void _addTag() {
    if (!_isEnabled) return;
    setState(() {
      _tags.add('Tag ${_tags.length + 1}');
    });
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
              Icon(icon, size: 18, color: colors.main),
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

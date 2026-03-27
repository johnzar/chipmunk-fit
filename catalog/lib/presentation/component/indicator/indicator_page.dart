import 'package:catalog/presentation/common/catalog_theme_switcher.dart';
import 'package:chip_component/indicator/fit_page_indicator.dart';
import 'package:chip_foundation/colors.dart';
import 'package:chip_module/scaffold/fit_app_bar.dart';
import 'package:chip_module/scaffold/fit_scaffold.dart';
import 'package:flutter/material.dart';

/// FitPageIndicator 테스트 페이지
class IndicatorPage extends StatefulWidget {
  const IndicatorPage({super.key});

  @override
  State<IndicatorPage> createState() => _IndicatorPageState();
}

class _IndicatorPageState extends State<IndicatorPage> {
  FitPageIndicatorStyle _style = FitPageIndicatorStyle.expanded;
  int _count = 5;
  int _currentIndex = 0;
  double _dotSize = 6.0;
  double _spacing = 2.0;
  bool _useCustomColors = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return FitScaffold(
      padding: EdgeInsets.zero,
      appBar: FitLeadingAppBar(
        title: 'FitPageIndicator',
        actions: const [CatalogThemeSwitcher(), SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프리뷰
            _SectionTitle(title: 'Preview'),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: colors.backgroundElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.dividerPrimary),
              ),
              child: Center(
                child: FitPageIndicator(
                  count: _count,
                  currentIndex: _currentIndex,
                  style: _style,
                  dotSize: _dotSize,
                  spacing: _spacing,
                  activeColor:
                      _useCustomColors ? colors.main : null,
                  inactiveColor:
                      _useCustomColors ? colors.grey300 : null,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 인덱스 조절
            _SectionTitle(title: 'Current Index: $_currentIndex'),
            Slider(
              value: _currentIndex.toDouble(),
              min: 0,
              max: (_count - 1).clamp(0, 99).toDouble(),
              divisions: (_count - 1).clamp(1, 99),
              onChanged: (v) => setState(() => _currentIndex = v.round()),
            ),

            const SizedBox(height: 16),

            // 스타일 선택
            _SectionTitle(title: 'Style'),
            const SizedBox(height: 8),
            SegmentedButton<FitPageIndicatorStyle>(
              segments: const [
                ButtonSegment(
                  value: FitPageIndicatorStyle.expanded,
                  label: Text('Expanded'),
                ),
                ButtonSegment(
                  value: FitPageIndicatorStyle.circle,
                  label: Text('Circle'),
                ),
              ],
              selected: {_style},
              onSelectionChanged: (v) => setState(() => _style = v.first),
            ),

            const SizedBox(height: 16),

            // 개수 조절
            _SectionTitle(title: 'Count: $_count'),
            Slider(
              value: _count.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => setState(() {
                _count = v.round();
                if (_currentIndex >= _count) {
                  _currentIndex = _count - 1;
                }
              }),
            ),

            const SizedBox(height: 16),

            // dot 크기 조절
            _SectionTitle(title: 'Dot Size: ${_dotSize.toStringAsFixed(0)}'),
            Slider(
              value: _dotSize,
              min: 4,
              max: 16,
              divisions: 12,
              onChanged: (v) => setState(() => _dotSize = v),
            ),

            const SizedBox(height: 16),

            // 간격 조절
            _SectionTitle(title: 'Spacing: ${_spacing.toStringAsFixed(0)}'),
            Slider(
              value: _spacing,
              min: 0,
              max: 8,
              divisions: 8,
              onChanged: (v) => setState(() => _spacing = v),
            ),

            const SizedBox(height: 16),

            // 커스텀 색상 토글
            SwitchListTile(
              title: const Text('Custom Colors (main / grey300)'),
              value: _useCustomColors,
              onChanged: (v) => setState(() => _useCustomColors = v),
              contentPadding: EdgeInsets.zero,
            ),

            const SizedBox(height: 32),

            // PageView 연동 데모
            _SectionTitle(title: 'PageView 연동 데모'),
            const SizedBox(height: 12),
            _PageViewDemo(),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _PageViewDemo extends StatefulWidget {
  @override
  State<_PageViewDemo> createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<_PageViewDemo> {
  final _controller = PageController();
  int _index = 0;
  final _pages = const [Colors.indigo, Colors.teal, Colors.orange, Colors.pink];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, index) {
                return Container(
                  color: _pages[index].withValues(alpha: 0.3),
                  child: Center(
                    child: Text(
                      'Page ${index + 1}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        FitPageIndicator(
          count: _pages.length,
          currentIndex: _index,
          activeColor: colors.textPrimary,
          inactiveColor: colors.grey300,
        ),
      ],
    );
  }
}

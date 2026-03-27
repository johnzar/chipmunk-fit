import 'package:flutter/material.dart';

import 'fit_page_indicator_style.dart';

export 'fit_page_indicator_style.dart';

/// 페이지 인디케이터 (dot indicator)
///
/// [FitPageIndicatorStyle.expanded] — active dot이 넓어지는 캡슐형
/// [FitPageIndicatorStyle.circle] — 원형 dot, active는 색상만 변경
class FitPageIndicator extends StatelessWidget {
  const FitPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.style = FitPageIndicatorStyle.expanded,
    this.activeColor,
    this.inactiveColor,
    this.dotSize = 6.0,
    this.activeDotWidth,
    this.spacing = 2.0,
    this.animationDuration = const Duration(milliseconds: 180),
    this.animationCurve = Curves.easeInOut,
  })  : assert(count >= 0),
        assert(currentIndex >= 0),
        assert(dotSize > 0),
        assert(spacing >= 0);

  /// 총 페이지 수
  final int count;

  /// 현재 활성 인덱스
  final int currentIndex;

  /// 인디케이터 스타일
  final FitPageIndicatorStyle style;

  /// 활성 dot 색상 (기본: [ColorScheme.primary])
  final Color? activeColor;

  /// 비활성 dot 색상 (기본: [Theme.dividerColor])
  final Color? inactiveColor;

  /// dot 크기 (높이, 비활성 너비)
  final double dotSize;

  /// 활성 dot 너비 ([FitPageIndicatorStyle.expanded]에서만 사용, 기본: dotSize * 2.33)
  final double? activeDotWidth;

  /// dot 간 간격
  final double spacing;

  /// 애니메이션 지속 시간
  final Duration animationDuration;

  /// 애니메이션 커브
  final Curve animationCurve;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? theme.colorScheme.primary;
    final effectiveInactiveColor = inactiveColor ?? theme.dividerColor;
    final effectiveActiveDotWidth = activeDotWidth ?? (dotSize * 2.33);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;

        switch (style) {
          case FitPageIndicatorStyle.expanded:
            return AnimatedContainer(
              duration: animationDuration,
              curve: animationCurve,
              margin: EdgeInsets.symmetric(horizontal: spacing),
              width: isActive ? effectiveActiveDotWidth : dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: isActive ? effectiveActiveColor : effectiveInactiveColor,
                borderRadius: BorderRadius.circular(dotSize),
              ),
            );

          case FitPageIndicatorStyle.circle:
            return AnimatedContainer(
              duration: animationDuration,
              curve: animationCurve,
              margin: EdgeInsets.symmetric(horizontal: spacing),
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? effectiveActiveColor : effectiveInactiveColor,
              ),
            );
        }
      }),
    );
  }
}

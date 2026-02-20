import 'package:flutter/material.dart';

import 'colors.dart';

/// 텍스트 대비 계산을 위한 `FitColors` 확장 유틸입니다.
///
/// 이 유틸은 WCAG(Web Content Accessibility Guidelines) 대비 기준을 근거로 작성되었습니다.
/// - 대비비(contrast ratio)는 `(밝은쪽 + 0.05) / (어두운쪽 + 0.05)`로 계산합니다.
/// - 일반 본문 텍스트는 보통 `4.5:1` 이상을 권장합니다.
/// - 큰 텍스트(제목급)는 `3.0:1`도 허용되지만, 기본값은 더 보수적으로 `4.5`를 사용합니다.
///
/// 이 유틸은 "토큰 우선 + 필요 시 보정(fallback)" 정책으로 동작합니다.
/// - Primary 텍스트: `textPrimary`를 먼저 사용합니다.
///   대비가 부족할 때만 `inverseText`로 보정합니다.
/// - Secondary 텍스트: `textSecondary`, `textTertiary`, `textDisabled`,
///   `inverseDisabled`, `inverseText` 후보 중에서 (primary 제외) 가장 적합한 값을 선택합니다.
///
/// 또한 반투명 배경(Alpha 컬러) 대응을 위해 [blendOn]을 받을 수 있습니다.
/// - 쉽게 말해 [blendOn]은 "이 색이 실제로 깔리는 바닥색"입니다.
/// - [blendOn]이 있으면 `Color.alphaBlend(background, blendOn)`으로 실제 렌더링 색을 만든 뒤
///   그 결과를 기준으로 대비를 계산합니다.
/// - [blendOn]이 없으면 전달받은 [background] 자체로 계산합니다.
///
/// 예시:
/// - `violetAlpha72`를 `backgroundBase` 위에 그린다면
///   `blendOn: palette.backgroundBase`를 넘겨야 실제 보이는 색 대비로 계산됩니다.
extension FitColorContrast on FitColors {
  /// 두 색상 [a], [b]의 WCAG 대비비(contrast ratio)를 계산합니다.
  ///
  /// 일반 본문 텍스트 가독성 기준으로는 `4.5` 이상을 자주 사용합니다.
  double contrastRatio(Color a, Color b) {
    final l1 = a.computeLuminance();
    final l2 = b.computeLuminance();
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// [background] 위에 올릴 Primary 텍스트 색상을 결정합니다.
  ///
  /// 왜 이렇게 동작하나요?
  /// - 디자인 시스템의 기본 의도는 `textPrimary`이므로 먼저 유지합니다.
  /// - 다만 접근성 대비가 부족한 배경에서는 읽기 어려워지므로 `inverseText`로 보정합니다.
  /// - 둘 다 기준 미달이면 "그나마 더 읽히는 값(대비비 높은 값)"을 선택합니다.
  ///
  /// 동작 순서:
  /// 1) `textPrimary`가 [minContrast]를 만족하면 그대로 사용
  /// 2) 부족하면 `inverseText`가 [minContrast]를 만족하는지 확인
  /// 3) 둘 다 부족하면 두 값 중 대비비가 더 큰 색상 선택
  ///
  /// [blendOn] 파라미터 안내:
  /// - null: [background] 자체를 "최종 배경색"으로 보고 계산
  /// - 값 존재: `background`와 [blendOn]을 합성한 결과를 "최종 배경색"으로 계산
  ///
  /// 반투명 색(`Alpha`)이면 [blendOn] 전달을 권장합니다.
  Color resolvePrimaryTextOn(
    Color background, {
    Color? blendOn,
    /// 기본값 4.5는 일반 본문 텍스트 기준입니다.
    ///
    /// 필요하면 컴포넌트 특성에 맞게 값을 낮추거나(예: 큰 텍스트 3.0),
    /// 더 엄격하게 높일 수 있습니다.
    double minContrast = 4.5,
  }) {
    final bg = _effectiveBackground(background, blendOn);
    final normal = textPrimary;
    final inverse = inverseText;

    if (contrastRatio(bg, normal) >= minContrast) {
      return normal;
    }
    if (contrastRatio(bg, inverse) >= minContrast) {
      return inverse;
    }
    return contrastRatio(bg, normal) >= contrastRatio(bg, inverse) ? normal : inverse;
  }

  /// [background] 위에 올릴 Secondary 텍스트 색상을 결정합니다.
  ///
  /// 왜 후보군이 여러 개인가요?
  /// - `textSecondary`, `textTertiary`, `textDisabled`는 일반적인 계층 표현용이고
  /// - `inverseDisabled`, `inverseText`는 어두운/강한 배경에서의 보정용입니다.
  ///
  /// 후보 우선순위:
  /// `textSecondary`, `textTertiary`, `textDisabled`, `inverseDisabled`, `inverseText`
  ///
  /// [primary]로 이미 선택된 색상은 후보에서 제외합니다.
  ///
  /// 동작 방식:
  /// 1) 후보 중 [minContrast]를 만족하는 색상만 먼저 추림
  /// 2) 만족하는 후보가 있으면 그 안에서 대비비가 가장 높은 값 선택
  /// 3) 만족 후보가 없으면 전체 후보 중 대비비가 가장 높은 값 선택
  ///
  /// [blendOn] 사용법은 [resolvePrimaryTextOn]과 동일합니다.
  Color resolveSecondaryTextOn(
    Color background, {
    required Color primary,
    Color? blendOn,
    /// 기본값 4.5는 일반 본문 텍스트 기준입니다.
    double minContrast = 4.5,
  }) {
    final bg = _effectiveBackground(background, blendOn);
    final candidates = <Color>[
      textSecondary,
      textTertiary,
      textDisabled,
      inverseDisabled,
      inverseText,
    ].where((c) => c != primary).toList();

    final passing = candidates.where((c) => contrastRatio(bg, c) >= minContrast).toList();
    final pool = passing.isNotEmpty ? passing : candidates;

    Color best = pool.first;
    double bestScore = contrastRatio(bg, best);
    for (final candidate in pool.skip(1)) {
      final score = contrastRatio(bg, candidate);
      if (score > bestScore) {
        best = candidate;
        bestScore = score;
      }
    }
    return best;
  }

  /// 실제 대비 계산에 사용할 배경색을 반환합니다.
  ///
  /// - [blendOn]이 null이면 원래 [background] 사용
  /// - [blendOn]이 있으면 alpha blend 결과 사용
  ///
  /// 예: `violetAlpha72` 같은 반투명 색은 단독 색상이 아니라
  /// 실제 배경과 섞인 결과로 보이므로, 합성 후 계산해야 정확합니다.
  Color _effectiveBackground(Color background, Color? blendOn) {
    if (blendOn == null) return background;
    return Color.alphaBlend(background, blendOn);
  }
}

import 'package:chip_assets/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

/// BuildContext에 텍스트 스타일 생성 기능 추가
extension FitTextStyleExtension on BuildContext {
  // 기본 설정
  static const _letterSpacing = -0.06;
  static const _defaultHeight = 1.4;

  // === Tokens ===

  TextStyle textStyle(FitTextToken token) {
    final spec = _textSpecs[token]!;
    return _style(
      fontSize: spec.fontSize,
      fontFamily: spec.fontFamily,
      color: spec.colorResolver?.call(this),
    );
  }

  // === Heading Styles ===

  TextStyle h1() => textStyle(FitTextToken.h1);

  TextStyle h2() => textStyle(FitTextToken.h2);

  TextStyle h3() => textStyle(FitTextToken.h3);

  TextStyle h4() => textStyle(FitTextToken.h4);

  // === Subtitle Styles ===

  TextStyle subtitle1() => textStyle(FitTextToken.subtitle1);

  TextStyle subtitle2() => textStyle(FitTextToken.subtitle2);

  TextStyle subtitle3() => textStyle(FitTextToken.subtitle3);

  TextStyle subtitle4() => textStyle(FitTextToken.subtitle4);

  TextStyle subtitle5() => textStyle(FitTextToken.subtitle5);

  TextStyle subtitle6() => textStyle(FitTextToken.subtitle6);

  TextStyle subtitle7() => textStyle(FitTextToken.subtitle7);

  // === Body Styles ===

  TextStyle body1() => textStyle(FitTextToken.body1);

  TextStyle body2() => textStyle(FitTextToken.body2);

  TextStyle body3() => textStyle(FitTextToken.body3);

  TextStyle body4() => textStyle(FitTextToken.body4);

  TextStyle body5() => textStyle(FitTextToken.body5);

  TextStyle body6() => textStyle(FitTextToken.body6);

  // === Button Style ===

  TextStyle button1() => textStyle(FitTextToken.button1);

  TextStyle button2() => textStyle(FitTextToken.button2);

  // === Caption Styles ===

  TextStyle caption1() => textStyle(FitTextToken.caption1);

  TextStyle caption2() => textStyle(FitTextToken.caption2);

  TextStyle caption3() => textStyle(FitTextToken.caption3);

  TextStyle caption4() => textStyle(FitTextToken.caption4);

  TextStyle caption5() => textStyle(FitTextToken.caption5);

  /// 공통 텍스트 스타일 생성
  TextStyle _style({
    required double fontSize,
    required String fontFamily,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      letterSpacing: _letterSpacing,
      height: _defaultHeight,
      color: color,
      fontStyle: FontStyle.normal,
      fontFamily: fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }
}

/// 텍스트 스타일 토큰
enum FitTextToken {
  // Headline
  h1,
  h2,
  h3,
  h4,
  // Subtitle
  subtitle1,
  subtitle2,
  subtitle3,
  subtitle4,
  subtitle5,
  subtitle6,
  subtitle7,
  // Body
  body1,
  body2,
  body3,
  body4,
  body5,
  body6,
  // Button
  button1,
  button2,
  // Caption
  caption1,
  caption2,
  caption3,
  caption4,
  caption5,
}

class _FitTextSpec {
  const _FitTextSpec({
    required this.fontSize,
    required this.fontFamily,
    this.colorResolver,
  });

  final double fontSize;
  final String fontFamily;
  final Color? Function(BuildContext context)? colorResolver;
}

final Map<FitTextToken, _FitTextSpec> _textSpecs = {
  // Headline
  FitTextToken.h1: _FitTextSpec(
    fontSize: 28,
    fontFamily: FontFamily.pretendardSemiBold,
    colorResolver: _textPrimaryColor,
  ),
  FitTextToken.h2: _FitTextSpec(
    fontSize: 24,
    fontFamily: FontFamily.pretendardSemiBold,
    colorResolver: _textPrimaryColor,
  ),
  FitTextToken.h3: _FitTextSpec(
    fontSize: 20,
    fontFamily: FontFamily.pretendardSemiBold,
    colorResolver: _textPrimaryColor,
  ),
  FitTextToken.h4: _FitTextSpec(
    fontSize: 18,
    fontFamily: FontFamily.pretendardSemiBold,
  ),

  // Subtitle
  FitTextToken.subtitle1: _FitTextSpec(
    fontSize: 20,
    fontFamily: FontFamily.pretendardSemiBold,
  ),
  FitTextToken.subtitle2: _FitTextSpec(
    fontSize: 20,
    fontFamily: FontFamily.pretendardMedium,
  ),
  FitTextToken.subtitle3: _FitTextSpec(
    fontSize: 18,
    fontFamily: FontFamily.pretendardSemiBold,
  ),
  FitTextToken.subtitle4: _FitTextSpec(
    fontSize: 16,
    fontFamily: FontFamily.pretendardSemiBold,
  ),
  FitTextToken.subtitle5: _FitTextSpec(
    fontSize: 15,
    fontFamily: FontFamily.pretendardSemiBold,
  ),
  FitTextToken.subtitle6: _FitTextSpec(
    fontSize: 14,
    fontFamily: FontFamily.pretendardSemiBold,
  ),
  FitTextToken.subtitle7: _FitTextSpec(
    fontSize: 13,
    fontFamily: FontFamily.pretendardSemiBold,
  ),

  // Body
  FitTextToken.body1: _FitTextSpec(
    fontSize: 18,
    fontFamily: FontFamily.pretendardRegular,
  ),
  FitTextToken.body2: _FitTextSpec(
    fontSize: 16,
    fontFamily: FontFamily.pretendardRegular,
  ),
  FitTextToken.body3: _FitTextSpec(
    fontSize: 15,
    fontFamily: FontFamily.pretendardRegular,
  ),
  FitTextToken.body4: _FitTextSpec(
    fontSize: 14,
    fontFamily: FontFamily.pretendardRegular,
  ),
  FitTextToken.body5: _FitTextSpec(
    fontSize: 13,
    fontFamily: FontFamily.pretendardRegular,
  ),
  FitTextToken.body6: _FitTextSpec(
    fontSize: 12,
    fontFamily: FontFamily.pretendardRegular,
  ),

  // Button
  FitTextToken.button1: _FitTextSpec(
    fontSize: 18,
    fontFamily: FontFamily.pretendardMedium,
  ),
  FitTextToken.button2: _FitTextSpec(
    fontSize: 16,
    fontFamily: FontFamily.pretendardMedium,
  ),

  // Caption
  FitTextToken.caption1: _FitTextSpec(
    fontSize: 12,
    fontFamily: FontFamily.pretendardSemiBold,
  ),
  FitTextToken.caption2: _FitTextSpec(
    fontSize: 10,
    fontFamily: FontFamily.pretendardSemiBold,
  ),
  FitTextToken.caption3: _FitTextSpec(
    fontSize: 11,
    fontFamily: FontFamily.pretendardSemiBold,
  ),
  FitTextToken.caption4: _FitTextSpec(
    fontSize: 9,
    fontFamily: FontFamily.pretendardSemiBold,
  ),
  FitTextToken.caption5: _FitTextSpec(
    fontSize: 8,
    fontFamily: FontFamily.pretendardSemiBold,
  ),
};

Color? _textPrimaryColor(BuildContext context) => context.fitColors.textPrimary;

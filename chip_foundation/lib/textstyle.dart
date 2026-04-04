import 'package:chip_assets/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

/// 폰트 크기 타입
enum FitTextSp {
  /// 최소 크기 (화면 비율 무시)
  MIN,

  /// 최대 크기 (화면 비율 무시)
  MAX,

  /// 화면 비율 적용
  SP
}

/// BuildContext에 텍스트 스타일 생성 기능 추가
extension FitTextStyleExtension on BuildContext {
  // 기본 설정
  static const _letterSpacing = -0.06;
  static const _defaultHeight = 1.4;
  static const _compactHeight = 1.0;

  // === Tokens ===

  TextStyle textStyle(
    FitTextToken token, {
    FitTextSp type = FitTextSp.MIN,
  }) {
    final spec = _textSpecs[token]!;
    return _style(
      fontSize: spec.fontSize,
      type: type,
      fontFamily: spec.fontFamily,
      height: spec.height,
      color: spec.colorResolver?.call(this),
    );
  }

  // === Heading Styles ===

  TextStyle h1({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.h1,
        type: type,
      );

  TextStyle h2({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.h2,
        type: type,
      );

  TextStyle h3({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.h3,
        type: type,
      );

  TextStyle h4({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.h4,
        type: type,
      );

  // === Subtitle Styles ===

  TextStyle subtitle1({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.subtitle1,
        type: type,
      );

  TextStyle subtitle2({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.subtitle2,
        type: type,
      );

  TextStyle subtitle3({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.subtitle3,
        type: type,
      );

  TextStyle subtitle4({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.subtitle4,
        type: type,
      );

  TextStyle subtitle5({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.subtitle5,
        type: type,
      );

  TextStyle subtitle6({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.subtitle6,
        type: type,
      );

  TextStyle subtitle7({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.subtitle7,
        type: type,
      );

  // === Body Styles ===

  TextStyle body1({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.body1,
        type: type,
      );

  TextStyle body2({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.body2,
        type: type,
      );

  TextStyle body3({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.body3,
        type: type,
      );

  TextStyle body4({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.body4,
        type: type,
      );

  TextStyle body5({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.body5,
        type: type,
      );

  TextStyle body6({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.body6,
        type: type,
      );

  // === Button Style ===

  TextStyle button1({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.button1,
        type: type,
      );

  TextStyle button2({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.button2,
        type: type,
      );

  // === Caption Styles ===

  TextStyle caption1({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.caption1,
        type: type,
      );

  TextStyle caption2({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.caption2,
        type: type,
      );

  TextStyle caption3({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.caption3,
        type: type,
      );

  TextStyle caption4({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.caption4,
        type: type,
      );

  TextStyle caption5({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.caption5,
        type: type,
      );

  // === Special Fonts ===

  TextStyle neodgm({FitTextSp type = FitTextSp.MIN}) => textStyle(
        FitTextToken.neodgm,
        type: type,
      );

  /// 공통 텍스트 스타일 생성
  TextStyle _style({
    required double fontSize,
    required FitTextSp type,
    required String fontFamily,
    double height = _defaultHeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: _fontSize(fontSize, type),
      letterSpacing: _letterSpacing,
      height: height,
      color: color,
      fontStyle: FontStyle.normal,
      fontFamily: fontFamily,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  /// 폰트 크기 계산
  double _fontSize(double base, FitTextSp type) => switch (type) {
        FitTextSp.MIN => base.spMin,
        FitTextSp.MAX => base.spMax,
        FitTextSp.SP => base.sp,
      };
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
  // Custom
  neodgm,
}

class _FitTextSpec {
  const _FitTextSpec({
    required this.fontSize,
    required this.fontFamily,
    this.height = FitTextStyleExtension._defaultHeight,
    this.colorResolver,
  });

  final double fontSize;
  final String fontFamily;
  final double height;
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
    height: FitTextStyleExtension._compactHeight,
  ),
  FitTextToken.button2: _FitTextSpec(
    fontSize: 16,
    fontFamily: FontFamily.pretendardMedium,
    height: FitTextStyleExtension._compactHeight,
  ),

  // Caption
  FitTextToken.caption1: _FitTextSpec(
    fontSize: 12,
    fontFamily: FontFamily.pretendardSemiBold,
    height: FitTextStyleExtension._compactHeight,
  ),
  FitTextToken.caption2: _FitTextSpec(
    fontSize: 10,
    fontFamily: FontFamily.pretendardSemiBold,
    height: FitTextStyleExtension._compactHeight,
  ),
  FitTextToken.caption3: _FitTextSpec(
    fontSize: 11,
    fontFamily: FontFamily.pretendardSemiBold,
    height: FitTextStyleExtension._compactHeight,
  ),
  FitTextToken.caption4: _FitTextSpec(
    fontSize: 9,
    fontFamily: FontFamily.pretendardSemiBold,
    height: FitTextStyleExtension._compactHeight,
  ),
  FitTextToken.caption5: _FitTextSpec(
    fontSize: 8,
    fontFamily: FontFamily.pretendardSemiBold,
    height: FitTextStyleExtension._compactHeight,
  ),

  // Custom
  FitTextToken.neodgm: _FitTextSpec(
    fontSize: 30,
    fontFamily: FontFamily.neodgm,
    height: FitTextStyleExtension._compactHeight,
  ),
};

Color? _textPrimaryColor(BuildContext context) => context.fitColors.textPrimary;

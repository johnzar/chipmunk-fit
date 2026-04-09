import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

/// 버튼 타입 정의
enum FitButtonType {
  primary,
  secondary,
  tertiary,
  ghost,
  destructive,
}

/// FitButton 스타일 유틸리티
class FitButtonStyle {
  FitButtonStyle._();

  static const defaultBorderRadius = 32.0;
  static const _disabledState = <WidgetState>{WidgetState.disabled};

  static _ResolvedButtonColors _resolve(
    BuildContext context,
    FitButtonType type,
  ) {
    final colors = context.fitColors;
    final filledStyle = Theme.of(context).filledButtonTheme.style;

    if (type == FitButtonType.primary) {
      final foreground =
          filledStyle?.foregroundColor?.resolve({}) ?? colors.staticBlack;
      return _ResolvedButtonColors(
        backgroundColor:
            filledStyle?.backgroundColor?.resolve({}) ?? colors.main,
        disabledBackgroundColor:
            filledStyle?.backgroundColor?.resolve(_disabledState) ??
                colors.green50,
        foregroundColor: foreground,
        disabledForegroundColor:
            filledStyle?.foregroundColor?.resolve(_disabledState) ??
                colors.inverseDisabled,
        loadingColor: foreground,
      );
    }

    if (type == FitButtonType.secondary) {
      return _ResolvedButtonColors(
        backgroundColor: colors.grey900,
        disabledBackgroundColor: colors.grey300,
        foregroundColor: colors.inverseText,
        disabledForegroundColor: colors.textSecondary,
        loadingColor: colors.inverseText,
      );
    }
    if (type == FitButtonType.tertiary) {
      return _ResolvedButtonColors(
        backgroundColor: colors.fillStrong,
        disabledBackgroundColor: colors.fillAlternative,
        foregroundColor: colors.textDisabled,
        disabledForegroundColor: colors.textTertiary,
        loadingColor: colors.textDisabled,
      );
    }
    if (type == FitButtonType.ghost) {
      return _ResolvedButtonColors(
        backgroundColor: Colors.transparent,
        disabledBackgroundColor: Colors.transparent,
        foregroundColor: colors.grey900,
        disabledForegroundColor: colors.grey300,
        borderSide: BorderSide(color: colors.grey400, width: 1.0),
        loadingColor: colors.grey900,
      );
    }
    if (type == FitButtonType.destructive) {
      return _ResolvedButtonColors(
        backgroundColor: colors.red500,
        disabledBackgroundColor: colors.red50,
        foregroundColor: colors.staticWhite,
        disabledForegroundColor: colors.inverseDisabled,
        loadingColor: colors.staticWhite,
      );
    }

    throw StateError('Unknown FitButtonType: $type');
  }

  /// 버튼 타입에 따른 로딩 색상 반환
  static Color loadingColorOf(BuildContext context, FitButtonType type) {
    return _resolve(context, type).loadingColor;
  }

  /// 버튼 타입에 따른 텍스트 색상 반환
  static Color textColorOf(
    BuildContext context,
    FitButtonType type, {
    required bool isEnabled,
  }) {
    final resolved = _resolve(context, type);
    return isEnabled
        ? resolved.foregroundColor
        : resolved.disabledForegroundColor;
  }

  /// 커스텀 ButtonStyle 생성
  static ButtonStyle styleFrom({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    Color? overlayColor,
    double? borderRadius,
    EdgeInsets? padding,
    TextStyle? textStyle,
    BorderSide? side,
    Size? minimumSize,
    double? elevation,
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledBackgroundColor;
        }
        return backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledForegroundColor;
        }
        return foregroundColor;
      }),
      overlayColor: WidgetStateProperty.all(overlayColor ?? Colors.transparent),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? defaultBorderRadius.r,
          ),
          side: side ?? BorderSide.none,
        ),
      ),
      padding: padding != null ? WidgetStateProperty.all(padding) : null,
      textStyle: textStyle != null ? WidgetStateProperty.all(textStyle) : null,
      elevation: elevation != null ? WidgetStateProperty.all(elevation) : null,
      minimumSize:
          minimumSize != null ? WidgetStateProperty.all(minimumSize) : null,
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  /// FitButtonType에 따른 기본 스타일 반환
  static ButtonStyle of(
    BuildContext context,
    FitButtonType type, {
    bool isRipple = false,
  }) {
    final colors = context.fitColors;
    final overlayColor =
        isRipple ? colors.grey600.withValues(alpha: 0.2) : Colors.transparent;
    final resolved = _resolve(context, type);

    return styleFrom(
      backgroundColor: resolved.backgroundColor,
      foregroundColor: resolved.foregroundColor,
      disabledBackgroundColor: resolved.disabledBackgroundColor,
      disabledForegroundColor: resolved.disabledForegroundColor,
      overlayColor: overlayColor,
      side: resolved.borderSide,
    );
  }
}

class _ResolvedButtonColors {
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color foregroundColor;
  final Color disabledForegroundColor;
  final BorderSide? borderSide;
  final Color loadingColor;

  const _ResolvedButtonColors({
    required this.backgroundColor,
    required this.disabledBackgroundColor,
    required this.foregroundColor,
    required this.disabledForegroundColor,
    this.borderSide,
    required this.loadingColor,
  });
}

/// ButtonStyle 병합을 위한 extension
extension ButtonStyleMerge on ButtonStyle {
  /// 다른 ButtonStyle과 병합 (this가 우선, other는 this의 null 필드를 채움)
  ButtonStyle merge(ButtonStyle? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: backgroundColor ?? other.backgroundColor,
      foregroundColor: foregroundColor ?? other.foregroundColor,
      overlayColor: overlayColor ?? other.overlayColor,
      shape: shape ?? other.shape,
      padding: padding ?? other.padding,
      textStyle: textStyle ?? other.textStyle,
      elevation: elevation ?? other.elevation,
      minimumSize: minimumSize ?? other.minimumSize,
      shadowColor: shadowColor ?? other.shadowColor,
      surfaceTintColor: surfaceTintColor ?? other.surfaceTintColor,
      side: side ?? other.side,
    );
  }
}

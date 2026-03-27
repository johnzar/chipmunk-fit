import 'dart:async';

import 'package:chip_component/fit_dot_loading.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';

/// DS 기본 버튼 컴포넌트.
///
/// 정책 요약:
/// - 로딩 상태(`isLoading`)에서는 탭 입력을 무시합니다.
/// - `child`가 `Text`일 때 자동 축소를 적용해 텍스트 overflow를 완화합니다.
/// - 최소 축소 배율에서도 넘치면 말줄임(`ellipsis`)으로 처리합니다.
class FitButton extends StatefulWidget {
  /// 새 [FitButton]을 생성합니다.
  ///
  /// `maxLines`는 1 이상이어야 하며, 기본값은 `1`입니다.
  const FitButton({
    super.key,
    required this.child,
    this.onPressed,
    this.onDisabledPressed,
    this.type = FitButtonType.primary,
    this.style,
    this.padding,
    this.isExpanded = false,
    this.isEnabled = true,
    this.isLoading = false,
    this.enableRipple = false,
    this.loadingColor,
    this.maxLines = 1,
  }) : assert(maxLines > 0);

  /// 버튼 내부 콘텐츠.
  final Widget child;

  /// 활성 상태에서 버튼 탭 시 호출됩니다.
  final VoidCallback? onPressed;

  /// 비활성 상태에서 버튼 탭 시 호출됩니다.
  ///
  /// 단, `isLoading == true`일 때는 호출되지 않습니다.
  final VoidCallback? onDisabledPressed;

  /// 버튼 타입 토큰.
  final FitButtonType type;

  /// 기본 버튼 스타일 위에 병합할 사용자 스타일.
  ///
  /// 병합 시 사용자 스타일이 우선 적용됩니다.
  final ButtonStyle? style;

  /// 내부 패딩 오버라이드 값.
  final EdgeInsets? padding;

  /// `true`이면 버튼이 가로 전체 폭을 사용합니다.
  final bool isExpanded;

  /// 버튼 활성화 여부.
  final bool isEnabled;

  /// 로딩 상태 여부.
  final bool isLoading;

  /// 터치 오버레이(리플) 사용 여부.
  final bool enableRipple;

  /// 로딩 인디케이터 색상 오버라이드.
  final Color? loadingColor;

  /// `Text` child 자동 축소 시 허용할 최대 라인 수.
  ///
  /// 기본값은 `1`입니다.
  final int maxLines;

  @override
  State<FitButton> createState() => _FitButtonState();
}

class _FitButtonState extends State<FitButton> {
  // 애니메이션 상수
  static const _kDebounceDuration = Duration(seconds: 1);
  static const _kAnimDuration = Duration(milliseconds: 600);
  static const _kPressedScale = 0.97;
  // 접근성 표준(WCAG)의 고정 수치가 아니라, 디자인 시스템 정책 값입니다.
  // 0.7 미만은 가독성이 급격히 떨어질 수 있어 하한으로 사용합니다.
  static const _kMinFontScale = 0.7;
  static final _kPressedCurve = Sprung.custom(damping: 8);
  static final _kReleasedCurve = Sprung.custom(damping: 6);

  bool _isPressed = false;
  Timer? _debounceTimer;

  bool get _isInteractive => widget.isEnabled && !widget.isLoading;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handlePress() {
    if (_debounceTimer?.isActive ?? false) return;
    widget.onPressed?.call();
    _debounceTimer = Timer(_kDebounceDuration, () {});
  }

  void _setPressed(bool pressed) {
    if (mounted) setState(() => _isPressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final padding =
        widget.padding ??
        EdgeInsets.symmetric(
          vertical: 18,
          horizontal: widget.isExpanded ? 20 : 14,
        );

    final button = GestureDetector(
      onTapDown: (_) {
        if (_isInteractive) {
          _setPressed(true);
        } else if (!widget.isLoading) {
          widget.onDisabledPressed?.call();
        }
      },
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedContainer(
        duration: _kAnimDuration,
        curve: _isPressed ? _kPressedCurve : _kReleasedCurve,
        transform: Matrix4.diagonal3Values(
          _isPressed ? _kPressedScale : 1.0,
          _isPressed ? _kPressedScale : 1.0,
          1.0,
        ),
        transformAlignment: Alignment.center,
        child: FilledButton(
          style: _buildStyle(context, padding),
          onPressed: _isInteractive ? _handlePress : null,
          child: _buildContent(context),
        ),
      ),
    );

    return widget.isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  /// 타입 스타일 + 상태 스타일 + 커스텀 스타일을 병합한 ButtonStyle 반환
  ButtonStyle _buildStyle(BuildContext context, EdgeInsets padding) {
    final baseStyle =
        FitButtonStyle.of(
          context,
          widget.type,
          isRipple: widget.enableRipple,
          isLoading: widget.isLoading,
        ).copyWith(
          padding: WidgetStateProperty.all(padding),
          minimumSize: WidgetStateProperty.all(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        );

    // 커스텀 스타일이 있으면 병합 (커스텀 우선)
    return widget.style?.merge(baseStyle) ?? baseStyle;
  }

  /// 로딩 상태일 때 로딩 인디케이터 표시
  Widget _buildContent(BuildContext context) {
    final normalizedChild = _buildNormalizedChild(context, widget.child);
    if (!widget.isLoading) return normalizedChild;

    return Stack(
      alignment: Alignment.center,
      children: [
        // 크기 유지용 숨김 child
        Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: normalizedChild,
        ),
        FitDotLoading(
          dotSize: 8,
          color:
              widget.loadingColor ??
              FitButtonStyle.loadingColorOf(context, widget.type),
        ),
      ],
    );
  }

  Widget _buildNormalizedChild(BuildContext context, Widget child) {
    if (child is! Text) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        final result = _resolveAutoSize(context, child, constraints);
        return _copyTextWithPolicy(
          context: context,
          source: child,
          scale: result.scale,
          useEllipsis: result.useEllipsis,
        );
      },
    );
  }

  _AutoSizeTextResult _resolveAutoSize(
    BuildContext context,
    Text source,
    BoxConstraints constraints,
  ) {
    if (!constraints.hasBoundedWidth || constraints.maxWidth <= 0) {
      return const _AutoSizeTextResult(scale: 1.0, useEllipsis: false);
    }

    final textDirection =
        source.textDirection ??
        Directionality.maybeOf(context) ??
        TextDirection.ltr;
    final maxWidth = constraints.maxWidth;

    // scale 배율에서 maxLines 내 배치 가능한지 측정.
    bool fits(double scale, {required bool useEllipsis}) {
      return _fitsText(
        context: context,
        source: source,
        textDirection: textDirection,
        maxWidth: maxWidth,
        scale: scale,
        useEllipsis: useEllipsis,
      );
    }

    if (fits(1.0, useEllipsis: false)) {
      return const _AutoSizeTextResult(scale: 1.0, useEllipsis: false);
    }

    if (!fits(_kMinFontScale, useEllipsis: false)) {
      return const _AutoSizeTextResult(
        scale: _kMinFontScale,
        useEllipsis: true,
      );
    }

    double low = _kMinFontScale;
    double high = 1.0;
    double best = _kMinFontScale;

    for (int i = 0; i < 12; i++) {
      final mid = (low + high) / 2;
      if (fits(mid, useEllipsis: false)) {
        best = mid;
        low = mid;
      } else {
        high = mid;
      }
    }

    return _AutoSizeTextResult(scale: best, useEllipsis: false);
  }

  bool _fitsText({
    required BuildContext context,
    required Text source,
    required TextDirection textDirection,
    required double maxWidth,
    required double scale,
    required bool useEllipsis,
  }) {
    final painter = TextPainter(
      text: _resolveTextSpan(context, source),
      textAlign: source.textAlign ?? TextAlign.center,
      textDirection: textDirection,
      locale: source.locale,
      strutStyle: source.strutStyle,
      textWidthBasis: source.textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: source.textHeightBehavior,
      maxLines: widget.maxLines,
      textScaler: _resolveTextScaler(context, source, autoScale: scale),
      ellipsis: useEllipsis ? '…' : null,
    );

    painter.layout(maxWidth: maxWidth);
    return !painter.didExceedMaxLines;
  }

  TextSpan _resolveTextSpan(BuildContext context, Text source) {
    final baseStyle = DefaultTextStyle.of(context).style.merge(source.style);

    if (source.data != null) {
      return TextSpan(text: source.data, style: baseStyle);
    }

    final rich = source.textSpan;
    if (rich == null) {
      return TextSpan(text: '', style: baseStyle);
    }

    return TextSpan(style: baseStyle, children: [rich]);
  }

  Text _copyTextWithPolicy({
    required BuildContext context,
    required Text source,
    required double scale,
    required bool useEllipsis,
  }) {
    final overflow = useEllipsis ? TextOverflow.ellipsis : source.overflow;
    final softWrap = widget.maxLines > 1 ? (source.softWrap ?? true) : false;

    if (source.data != null) {
      return Text(
        source.data!,
        key: source.key,
        style: source.style,
        strutStyle: source.strutStyle,
        textAlign: source.textAlign ?? TextAlign.center,
        textDirection: source.textDirection,
        locale: source.locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: _resolveTextScaler(context, source, autoScale: scale),
        semanticsLabel: source.semanticsLabel,
        textWidthBasis: source.textWidthBasis,
        textHeightBehavior: source.textHeightBehavior,
        selectionColor: source.selectionColor,
        maxLines: widget.maxLines,
      );
    }

    return Text.rich(
      source.textSpan ?? const TextSpan(text: ''),
      key: source.key,
      style: source.style,
      strutStyle: source.strutStyle,
      textAlign: source.textAlign ?? TextAlign.center,
      textDirection: source.textDirection,
      locale: source.locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: _resolveTextScaler(context, source, autoScale: scale),
      semanticsLabel: source.semanticsLabel,
      textWidthBasis: source.textWidthBasis,
      textHeightBehavior: source.textHeightBehavior,
      selectionColor: source.selectionColor,
      maxLines: widget.maxLines,
    );
  }

  TextScaler _resolveTextScaler(
    BuildContext context,
    Text source, {
    required double autoScale,
  }) {
    final baseScaler = source.textScaler ?? MediaQuery.textScalerOf(context);
    if ((autoScale - 1.0).abs() < 1e-6) return baseScaler;
    return _ScaledTextScaler(baseScaler: baseScaler, autoScale: autoScale);
  }
}

class _AutoSizeTextResult {
  final double scale;
  final bool useEllipsis;

  const _AutoSizeTextResult({required this.scale, required this.useEllipsis});
}

class _ScaledTextScaler implements TextScaler {
  const _ScaledTextScaler({required this.baseScaler, required this.autoScale});

  final TextScaler baseScaler;
  final double autoScale;

  @override
  double scale(double fontSize) => baseScaler.scale(fontSize) * autoScale;

  @override
  double get textScaleFactor => scale(16) / 16;

  @override
  TextScaler clamp({
    double minScaleFactor = 0,
    double maxScaleFactor = double.infinity,
  }) {
    if (autoScale <= 0) {
      return TextScaler.linear(
        0,
      ).clamp(minScaleFactor: minScaleFactor, maxScaleFactor: maxScaleFactor);
    }

    return _ScaledTextScaler(
      baseScaler: baseScaler.clamp(
        minScaleFactor: minScaleFactor / autoScale,
        maxScaleFactor: maxScaleFactor / autoScale,
      ),
      autoScale: autoScale,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _ScaledTextScaler &&
        other.baseScaler == baseScaler &&
        other.autoScale == autoScale;
  }

  @override
  int get hashCode => Object.hash(baseScaler, autoScale);
}

import 'package:chip_component/button/fit_button.dart';
import 'package:chip_foundation/buttonstyle.dart';
import 'package:chip_foundation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 키보드 상태에 맞춰 하단 고정 버튼의 패딩/모서리를 애니메이션하는 래퍼입니다.
///
/// 내부적으로 [FitButton]을 사용하며, 버튼 관련 옵션을 그대로 전달합니다.
/// 바텀시트처럼 부모에서 safe area를 이미 처리한 경우 `useSafeArea: false`를 권장합니다.
class FitAnimatedBottomButton extends StatefulWidget {
  /// [FitAnimatedBottomButton]를 생성합니다.
  ///
  /// [maxLines]는 1 이상이어야 합니다.
  const FitAnimatedBottomButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.type = FitButtonType.primary,
    this.style,
    this.isEnabled = true,
    this.isLoading = false,
    this.loadingColor,
    this.useSafeArea = true,
    this.backgroundColor,
    this.borderRadius,
    this.maxLines = 1,
  }) : assert(maxLines > 0);

  /// 버튼 콘텐츠입니다.
  final Widget child;

  /// 버튼 탭 콜백입니다.
  final VoidCallback? onPressed;

  /// 버튼 타입 토큰입니다.
  final FitButtonType type;

  /// 기본 스타일 위에 덮어쓸 커스텀 스타일입니다.
  final ButtonStyle? style;

  /// 버튼 활성화 여부입니다.
  final bool isEnabled;

  /// 로딩 상태 여부입니다.
  final bool isLoading;

  /// 로딩 인디케이터 색상 오버라이드입니다.
  final Color? loadingColor;

  /// 하단 safe area 반영 여부입니다.
  final bool useSafeArea;

  /// 버튼 컨테이너 배경색 오버라이드입니다.
  final Color? backgroundColor;

  /// 버튼 기본 radius 오버라이드입니다.
  final double? borderRadius;

  /// 버튼 텍스트 최대 라인 수입니다.
  final int maxLines;

  @override
  State<FitAnimatedBottomButton> createState() => _FitAnimatedBottomButtonState();
}

class _FitAnimatedBottomButtonState extends State<FitAnimatedBottomButton>
    with WidgetsBindingObserver {
  static const _kKeyboardThreshold = 50.0;
  static const _kAnimDuration = Duration(milliseconds: 200);
  static const _kSafeAreaPadding = 8.0;

  double _keyboardHeight = 0;
  double? _cachedRadius;

  bool get _isKeyboardVisible => _keyboardHeight > _kKeyboardThreshold;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncKeyboardHeight());
  }

  @override
  void didUpdateWidget(FitAnimatedBottomButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // shape 기준 radius 캐시를 갱신합니다.
    if (oldWidget.borderRadius != widget.borderRadius ||
        oldWidget.style != widget.style) {
      _cachedRadius = null;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() => _syncKeyboardHeight();

  void _syncKeyboardHeight() {
    if (!mounted) return;
    final view = WidgetsBinding.instance.platformDispatcher.implicitView;
    if (view == null) return;
    final height = view.viewInsets.bottom / view.devicePixelRatio;
    if (_keyboardHeight != height) {
      setState(() => _keyboardHeight = height);
    }
  }

  /// radius 해석 우선순위: `widget.borderRadius > style.shape > 기본값`.
  double get _baseRadius => _cachedRadius ??= _resolveRadius();

  double _resolveRadius() {
    if (widget.borderRadius != null) return widget.borderRadius!;

    final shape = widget.style?.shape?.resolve({});
    if (shape is RoundedRectangleBorder) {
      final resolved = shape.borderRadius.resolve(
        Directionality.maybeOf(context) ?? TextDirection.ltr,
      );
      return resolved.topLeft.x;
    }
    return FitButtonStyle.defaultBorderRadius.r;
  }

  double _resolveSafeBottomPadding(MediaQueryData query) {
    if (!widget.useSafeArea) return 0.0;
    final safeBottom = query.padding.bottom;
    return safeBottom > 0 ? safeBottom + _kSafeAreaPadding : 0.0;
  }

  /// 키보드 상태(anim)에 따라 컨테이너 패딩을 계산합니다.
  EdgeInsets _resolveContainerPadding(double anim, double safeBottomPadding) {
    final topPadding = 12.h * anim;
    final bottomPadding = widget.useSafeArea
        ? (safeBottomPadding > 0 ? safeBottomPadding : 16.h * anim)
        : 0.0;

    return EdgeInsets.only(
      left: 20.w * anim,
      right: 20.w * anim,
      top: topPadding,
      bottom: bottomPadding,
    );
  }

  OutlinedBorder _resolveAnimatedShape(double anim) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_baseRadius * anim),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.fitColors;
    final query = MediaQuery.of(context);
    final bgColor = widget.backgroundColor ?? colors.backgroundElevated;
    final safeBottomPadding = _resolveSafeBottomPadding(query);
    return TweenAnimationBuilder<double>(
      duration: _kAnimDuration,
      curve: Curves.easeOutCubic,
      tween: Tween(end: _isKeyboardVisible ? 0.0 : 1.0),
      builder: (context, anim, _) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          boxShadow: anim > 0.5
              ? [
                  BoxShadow(
                    color: bgColor.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ]
              : null,
        ),
        padding: _resolveContainerPadding(anim, safeBottomPadding),
        child: FitButton(
          isExpanded: true,
          type: widget.type,
          style: _animatedStyle(anim),
          isEnabled: widget.isEnabled && !widget.isLoading,
          isLoading: widget.isLoading,
          loadingColor: widget.loadingColor,
          maxLines: widget.maxLines,
          onPressed: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }

  /// 애니메이션 진행도에 맞는 shape를 스타일에 반영합니다.
  ButtonStyle _animatedStyle(double anim) {
    final shape = WidgetStateProperty.all(_resolveAnimatedShape(anim));
    return widget.style?.copyWith(shape: shape) ?? ButtonStyle(shape: shape);
  }
}

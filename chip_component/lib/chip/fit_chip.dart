import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';

/// iOS 쿠퍼티노 스타일의 Chip 컨테이너 위젯
///
/// FitChip은 칩 형태의 컨테이너만 제공합니다.
/// 내부 컨텐츠는 child로 자유롭게 커스터마이징할 수 있습니다.
///
/// 기능:
/// - 칩 모양의 컨테이너 (배경색, 테두리, 패딩, 그림자)
/// - 탭 제스처 및 애니메이션
/// - 선택 상태 관리
/// - 내부 컨텐츠는 child로 완전히 커스터마이징
class FitChip extends StatefulWidget {
  static const double defaultPressedScale = 0.97;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 600);

  /// 칩 내부 컨텐츠
  final Widget child;

  /// 선택 상태
  final bool isSelected;

  /// 선택 상태 변경 콜백
  final ValueChanged<bool>? onSelected;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 배경색
  final Color? backgroundColor;

  /// 선택된 배경색
  final Color? selectedBackgroundColor;

  /// 테두리 색상
  final Color? borderColor;

  /// 선택된 테두리 색상
  final Color? selectedBorderColor;

  /// 테두리 두께
  final double borderWidth;

  /// 선택된 테두리 두께
  final double? selectedBorderWidth;

  /// 패딩
  final EdgeInsets padding;

  /// 모서리 반경
  final double borderRadius;

  /// 활성화 상태
  final bool isEnabled;

  /// 칩의 눌림/복원 모션 duration 오버라이드용 파라미터입니다.
  ///
  /// 기본 모션 정책은 [FitButton]과 동일한 `600ms`입니다.
  /// 향후 제거될 수 있는 하위 호환 옵션입니다.
  final Duration animationDuration;

  /// 고도 (그림자)
  final double elevation;

  /// 칩의 눌림 스케일 오버라이드용 파라미터입니다.
  ///
  /// 기본 모션 정책은 [FitButton]과 동일한 `0.97`입니다.
  /// 향후 제거될 수 있는 하위 호환 옵션입니다.
  final double pressedScale;

  const FitChip({
    super.key,
    required this.child,
    this.isSelected = false,
    this.onSelected,
    this.onTap,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.borderColor,
    this.selectedBorderColor,
    this.borderWidth = 1.0,
    this.selectedBorderWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.borderRadius = 16.0,
    this.isEnabled = true,
    @Deprecated('Use default FitButton motion policy.')
    this.animationDuration = defaultAnimationDuration,
    this.elevation = 0,
    @Deprecated('Use default FitButton motion policy.')
    this.pressedScale = defaultPressedScale,
  });

  @override
  State<FitChip> createState() => _FitChipState();
}

class _FitChipState extends State<FitChip> {
  static final _kPressedCurve = Sprung.custom(damping: 8);
  static final _kReleasedCurve = Sprung.custom(damping: 6);
  static const _kMinPressedVisibleDuration = Duration(milliseconds: 80);

  bool _isPressed = false;
  DateTime? _pressedAt;
  int _pressVersion = 0;
  bool get _isEnabled =>
      widget.isEnabled && (widget.onTap != null || widget.onSelected != null);

  void _onTapDown(TapDownDetails details) {
    if (_isEnabled) {
      _pressVersion += 1;
      _pressedAt = DateTime.now();
      setState(() => _isPressed = true);
    }
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    final version = _pressVersion;
    _handleTap();
    await _releasePressed(version);
  }

  void _onTapCancel() {
    _pressVersion += 1;
    _pressedAt = null;
    setState(() => _isPressed = false);
  }

  Future<void> _releasePressed(int version) async {
    final pressedAt = _pressedAt;
    if (pressedAt != null) {
      final elapsed = DateTime.now().difference(pressedAt);
      final remaining = _kMinPressedVisibleDuration - elapsed;
      if (remaining > Duration.zero) {
        await Future.delayed(remaining);
      }
    }

    if (!mounted || version != _pressVersion) return;
    _pressedAt = null;
    setState(() => _isPressed = false);
  }

  void _handleTap() {
    if (!_isEnabled) return;

    if (widget.onSelected != null) {
      widget.onSelected?.call(!widget.isSelected);
    } else {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 색상 결정 - 사용자 지정 색상 우선
    final Color backgroundColor = widget.isSelected
        ? (widget.selectedBackgroundColor ??
            theme.primaryColor.withValues(alpha: 0.1))
        : (widget.backgroundColor ??
            theme.chipTheme.backgroundColor ??
            Colors.grey.shade200);

    final Color borderColor = widget.isSelected
        ? (widget.selectedBorderColor ?? theme.primaryColor)
        : (widget.borderColor ?? Colors.transparent);

    // 선택 상태에서는 기본 테두리보다 약간 두껍게 보여 구분감을 높인다.
    final double borderWidth = widget.isSelected
        ? (widget.selectedBorderWidth ?? (widget.borderWidth + 0.4))
        : widget.borderWidth;

    // disabled 상태일 때만 opacity 적용 (사용자 지정 alpha 값 보존)
    final Color effectiveBackgroundColor = _isEnabled
        ? backgroundColor
        : backgroundColor.withValues(alpha: backgroundColor.a * 0.5);

    final effectiveScale = widget.pressedScale;
    final effectiveDuration = widget.animationDuration;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: effectiveDuration,
        curve: _isPressed ? _kPressedCurve : _kReleasedCurve,
        transform: Matrix4.diagonal3Values(
          _isPressed ? effectiveScale : 1.0,
          _isPressed ? effectiveScale : 1.0,
          1.0,
        ),
        transformAlignment: Alignment.center,
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            boxShadow: widget.elevation > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: widget.elevation,
                      offset: Offset(0, widget.elevation / 2),
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

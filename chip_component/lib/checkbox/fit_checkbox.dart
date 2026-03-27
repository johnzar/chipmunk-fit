import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fit_checkbox_painter.dart';
import 'fit_checkbox_style.dart';

/// 커스텀 페인터 기반 체크박스입니다.
///
/// - 최소 44×44 터치 영역 보장 (WCAG 2.5.8)
/// - 키보드 Space/Enter 토글 지원
/// - [Semantics]를 통한 스크린리더 접근성 제공
/// - 탭 시 스케일 피드백 애니메이션
class FitCheckbox extends StatefulWidget {
  const FitCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.style = FitCheckboxStyle.material,
    this.size = 20.0,
    this.activeColor,
    this.checkColor,
    this.inactiveColor,
    this.borderColor,
    this.borderWidth = 2.0,
    this.hasError = false,
    this.errorColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.label,
    this.labelStyle,
    this.labelOnLeft = false,
    this.spacing = 8.0,
  })  : assert(size > 0),
        assert(borderWidth > 0),
        assert(spacing >= 0);

  final bool value;
  final ValueChanged<bool>? onChanged;
  final FitCheckboxStyle style;
  final double size;
  final Color? activeColor;
  final Color? checkColor;
  final Color? inactiveColor;
  final Color? borderColor;
  final double borderWidth;
  final bool hasError;
  final Color? errorColor;
  final Duration animationDuration;
  final String? label;
  final TextStyle? labelStyle;
  final bool labelOnLeft;
  final double spacing;

  @override
  State<FitCheckbox> createState() => _FitCheckboxState();
}

class _FitCheckboxState extends State<FitCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _checkAnimation;
  bool _isPressed = false;

  bool get _isEnabled => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );
    _checkAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant FitCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
    if (oldWidget.value != widget.value) {
      widget.value ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isEnabled) widget.onChanged?.call(!widget.value);
  }

  void _onTapDown(TapDownDetails _) {
    if (_isEnabled) setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    _toggle();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveActiveColor = widget.hasError
        ? (widget.errorColor ?? Colors.red)
        : (widget.activeColor ?? theme.primaryColor);
    final effectiveCheckColor = widget.checkColor ?? Colors.white;
    final effectiveBorderColor = widget.hasError
        ? (widget.errorColor ?? Colors.red)
        : (widget.borderColor ?? theme.dividerColor);

    final resolvedActive = _applyEnabled(effectiveActiveColor);
    final resolvedBorder = _applyEnabled(effectiveBorderColor);

    final checkboxVisual = AnimatedBuilder(
      animation: _checkAnimation,
      builder: (context, _) {
        return AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: _buildBox(
            resolvedActive,
            effectiveCheckColor,
            resolvedBorder,
          ),
        );
      },
    );

    if (widget.label == null) {
      return Semantics(
        checked: widget.value,
        enabled: _isEnabled,
        child: Focus(
          onKeyEvent: _handleKeyEvent,
          child: GestureDetector(
            onTapDown: _isEnabled ? _onTapDown : null,
            onTapUp: _isEnabled ? _onTapUp : null,
            onTapCancel: _isEnabled ? _onTapCancel : null,
            behavior: HitTestBehavior.opaque,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              child: Center(child: checkboxVisual),
            ),
          ),
        ),
      );
    }

    final defaultLabelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: _isEnabled ? null : theme.disabledColor,
    );
    final text = Flexible(
      child: Text(
        widget.label!,
        style: widget.labelStyle ?? defaultLabelStyle,
      ),
    );

    final children = <Widget>[
      checkboxVisual,
      SizedBox(width: widget.spacing),
      text,
    ];

    return Semantics(
      label: widget.label,
      checked: widget.value,
      enabled: _isEnabled,
      child: MergeSemantics(
        child: Focus(
          onKeyEvent: _handleKeyEvent,
          child: GestureDetector(
            onTapDown: _isEnabled ? _onTapDown : null,
            onTapUp: _isEnabled ? _onTapUp : null,
            onTapCancel: _isEnabled ? _onTapCancel : null,
            behavior: HitTestBehavior.opaque,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children:
                    widget.labelOnLeft ? children.reversed.toList() : children,
              ),
            ),
          ),
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!_isEnabled) return KeyEventResult.ignored;
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.space ||
        event.logicalKey == LogicalKeyboardKey.enter) {
      _toggle();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Widget _buildBox(Color activeColor, Color checkColor, Color borderColor) {
    final progress = _checkAnimation.value;

    switch (widget.style) {
      case FitCheckboxStyle.material:
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Color.lerp(Colors.transparent, activeColor, progress),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Color.lerp(borderColor, activeColor, progress)!,
              width: widget.borderWidth,
            ),
          ),
          child: progress > 0
              ? CustomPaint(
                  painter: FitCheckboxPainter(
                    progress: progress,
                    color: checkColor,
                    strokeWidth: 2.5,
                  ),
                )
              : null,
        );

      case FitCheckboxStyle.rounded:
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Color.lerp(Colors.transparent, activeColor, progress),
            shape: BoxShape.circle,
            border: Border.all(
              color: Color.lerp(borderColor, activeColor, progress)!,
              width: widget.borderWidth,
            ),
          ),
          child: progress > 0
              ? CustomPaint(
                  painter: FitCheckboxPainter(
                    progress: progress,
                    color: checkColor,
                    strokeWidth: 2.5,
                  ),
                )
              : null,
        );

      case FitCheckboxStyle.outlined:
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Color.lerp(borderColor, activeColor, progress)!,
              width: widget.borderWidth,
            ),
          ),
          child: progress > 0
              ? CustomPaint(
                  painter: FitCheckboxPainter(
                    progress: progress,
                    color: activeColor,
                    strokeWidth: 2.5,
                  ),
                )
              : null,
        );
    }
  }

  Color _applyEnabled(Color color) {
    if (_isEnabled) return color;
    return color.withValues(alpha: color.a * 0.45);
  }
}

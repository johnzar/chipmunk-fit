import 'package:flutter/material.dart';

import 'fit_checkbox_style.dart';

/// 접근성과 플랫폼 적응형 렌더링을 지원하는 체크박스입니다.
///
/// 내부 구현은 [Checkbox.adaptive]를 사용합니다.
class FitCheckbox extends StatelessWidget {
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
    this.borderWidth = 1.6,
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

  /// 하위 호환용 파라미터입니다. adaptive 기본 애니메이션을 사용합니다.
  final Duration animationDuration;

  final String? label;
  final TextStyle? labelStyle;
  final bool labelOnLeft;
  final double spacing;

  bool get _isEnabled => onChanged != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveErrorColor = errorColor ?? theme.colorScheme.error;
    final effectiveActiveColor = hasError
        ? effectiveErrorColor
        : (activeColor ?? theme.colorScheme.primary);
    final effectiveInactiveColor = inactiveColor ?? theme.unselectedWidgetColor;
    final effectiveBorderColor = hasError
        ? effectiveErrorColor
        : (borderColor ?? effectiveInactiveColor);

    final resolvedActive =
        _applyEnabledOpacity(effectiveActiveColor, _isEnabled);
    final resolvedInactive =
        _applyEnabledOpacity(effectiveInactiveColor, _isEnabled);
    final resolvedBorder =
        _applyEnabledOpacity(effectiveBorderColor, _isEnabled);

    final checkbox = SizedBox(
      width: size,
      height: size,
      child: Transform.scale(
        scale: size / 18,
        alignment: Alignment.center,
        child: Checkbox.adaptive(
          value: value,
          onChanged: _isEnabled
              ? (next) {
                  if (next != null) onChanged?.call(next);
                }
              : null,
          side: BorderSide(
            color: value ? resolvedActive : resolvedBorder,
            width: borderWidth,
          ),
          shape: _resolveShape(),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              if (style == FitCheckboxStyle.outlined) {
                return Colors.transparent;
              }
              return resolvedActive;
            }

            if (style == FitCheckboxStyle.material) {
              return resolvedInactive.withValues(alpha: 0.16);
            }

            return Colors.transparent;
          }),
          checkColor: _resolveCheckColor(resolvedActive),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );

    if (label == null) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        child: Center(child: checkbox),
      );
    }

    final defaultLabelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: _isEnabled ? null : theme.disabledColor,
    );

    Widget text = Text(label!, style: labelStyle ?? defaultLabelStyle);
    if (_isEnabled) {
      text = GestureDetector(
        onTap: () => onChanged?.call(!value),
        behavior: HitTestBehavior.translucent,
        child: text,
      );
    }

    final children = <Widget>[checkbox, SizedBox(width: spacing), text];

    return Semantics(
      label: label,
      child: MergeSemantics(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: labelOnLeft ? children.reversed.toList() : children,
          ),
        ),
      ),
    );
  }

  OutlinedBorder _resolveShape() {
    switch (style) {
      case FitCheckboxStyle.material:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
      case FitCheckboxStyle.rounded:
        return const CircleBorder();
      case FitCheckboxStyle.outlined:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));
    }
  }

  Color _resolveCheckColor(Color active) {
    if (style == FitCheckboxStyle.outlined) {
      return checkColor ?? active;
    }
    return checkColor ?? Colors.white;
  }

  Color _applyEnabledOpacity(Color color, bool enabled) {
    if (enabled) return color;
    return color.withValues(alpha: color.a * 0.45);
  }
}

import 'package:flutter/material.dart';

/// 플랫폼 기본 스타일을 따르는 adaptive 라디오 버튼 래퍼입니다.
///
/// 내부 구현은 [Radio.adaptive]를 사용합니다.
class FitRadioButton<T> extends StatelessWidget {
  const FitRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.size = 22.0,
    this.activeColor,
    this.checkColor,
    this.inactiveColor,
    this.borderColor,
    this.hasError = false,
    this.errorColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.label,
    this.labelStyle,
    this.labelOnLeft = false,
    this.spacing = 8.0,
  })  : assert(size > 0),
        assert(spacing >= 0);

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final double size;
  final Color? activeColor;

  /// 하위 호환용 파라미터입니다. material 스타일에서는 직접 사용하지 않습니다.
  final Color? checkColor;
  final Color? inactiveColor;
  final Color? borderColor;
  final bool hasError;
  final Color? errorColor;

  /// 하위 호환용 파라미터입니다. adaptive 기본 애니메이션을 사용합니다.
  final Duration animationDuration;

  final String? label;
  final TextStyle? labelStyle;
  final bool labelOnLeft;
  final double spacing;

  bool get _isEnabled => onChanged != null;
  bool get _isSelected => value == groupValue;

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

    final radioCore = SizedBox(
      width: size,
      height: size,
      child: Transform.scale(
        scale: size / 20,
        alignment: Alignment.center,
        child: Radio.adaptive(
          value: value,
          // ignore: deprecated_member_use
          groupValue: groupValue,
          // ignore: deprecated_member_use
          onChanged: _isEnabled ? onChanged : null,
          activeColor: resolvedActive,
          useCupertinoCheckmarkStyle: false,
          side: BorderSide(
            color: _isSelected ? resolvedActive : resolvedBorder,
            width: 2.0,
          ),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return resolvedActive;
            }
            return resolvedInactive;
          }),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );

    final radio = radioCore;

    if (label == null) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
        child: Center(child: radio),
      );
    }

    final defaultLabelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: _isEnabled ? null : theme.disabledColor,
    );

    Widget text = Text(label!, style: labelStyle ?? defaultLabelStyle);
    if (_isEnabled) {
      text = GestureDetector(
        onTap: _isSelected ? null : () => onChanged?.call(value),
        behavior: HitTestBehavior.translucent,
        child: text,
      );
    }

    final children = <Widget>[radio, SizedBox(width: spacing), text];

    return MergeSemantics(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 44),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: labelOnLeft ? children.reversed.toList() : children,
        ),
      ),
    );
  }

  Color _applyEnabledOpacity(Color color, bool enabled) {
    if (enabled) return color;
    return color.withValues(alpha: color.a * 0.45);
  }
}

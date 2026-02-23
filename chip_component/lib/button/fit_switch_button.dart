import 'package:flutter/material.dart';
import 'package:chip_foundation/colors.dart';

/// 플랫폼 기본 스타일을 따르는 adaptive 스위치 래퍼입니다.
///
/// `onToggle`는 변경 이후 상태(`nextValue`)를 전달합니다.
class FitSwitchButton extends StatefulWidget {
  final ValueChanged<bool> onToggle;
  final bool isOn;
  final Duration debounceDuration;
  final Color? activeColor;
  final Color? inactiveColor;

  const FitSwitchButton({
    super.key,
    required this.onToggle,
    required this.isOn,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<FitSwitchButton> createState() => _FitSwitchButtonState();
}

class _FitSwitchButtonState extends State<FitSwitchButton> {
  DateTime? _lastToggleTime;

  void _handleToggle(bool nextValue) {
    final now = DateTime.now();
    final lastToggleTime = _lastToggleTime;
    if (lastToggleTime != null &&
        now.difference(lastToggleTime) < widget.debounceDuration) {
      return;
    }

    _lastToggleTime = now;
    widget.onToggle(nextValue);
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.activeColor ?? context.fitColors.main;
    final inactiveColor = widget.inactiveColor ?? context.fitColors.grey300;

    return Switch.adaptive(
      value: widget.isOn,
      onChanged: _handleToggle,
      activeTrackColor: activeColor,
      inactiveTrackColor: inactiveColor,
    );
  }
}

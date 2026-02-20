import 'package:chip_foundation/buttonstyle.dart';

class AnimatedBottomButtonTypeItem {
  final FitButtonType type;
  final String label;

  const AnimatedBottomButtonTypeItem({
    required this.type,
    required this.label,
  });
}

const animatedBottomButtonTypeItems = <AnimatedBottomButtonTypeItem>[
  AnimatedBottomButtonTypeItem(type: FitButtonType.primary, label: 'Primary'),
  AnimatedBottomButtonTypeItem(
      type: FitButtonType.secondary, label: 'Secondary'),
  AnimatedBottomButtonTypeItem(type: FitButtonType.tertiary, label: 'Tertiary'),
  AnimatedBottomButtonTypeItem(type: FitButtonType.ghost, label: 'Ghost'),
  AnimatedBottomButtonTypeItem(
      type: FitButtonType.destructive, label: 'Destructive'),
];

const animatedBottomButtonMaxLinesOptions = <int>[1, 2, 3];

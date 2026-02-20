import 'package:chip_foundation/buttonstyle.dart';

class ButtonTypeMeta {
  final FitButtonType type;
  final String label;
  final String description;

  const ButtonTypeMeta({
    required this.type,
    required this.label,
    required this.description,
  });
}

class ButtonStateMeta {
  final String label;
  final bool isEnabled;
  final bool isLoading;

  const ButtonStateMeta({
    required this.label,
    required this.isEnabled,
    required this.isLoading,
  });
}

const buttonTypeMetas = <ButtonTypeMeta>[
  ButtonTypeMeta(
    type: FitButtonType.primary,
    label: 'Primary',
    description: '핵심 CTA 액션',
  ),
  ButtonTypeMeta(
    type: FitButtonType.secondary,
    label: 'Secondary',
    description: '보조 액션',
  ),
  ButtonTypeMeta(
    type: FitButtonType.tertiary,
    label: 'Tertiary',
    description: '중립 액션',
  ),
  ButtonTypeMeta(
    type: FitButtonType.ghost,
    label: 'Ghost',
    description: '경계선 기반 액션',
  ),
  ButtonTypeMeta(
    type: FitButtonType.destructive,
    label: 'Destructive',
    description: '위험/삭제 액션',
  ),
];

const buttonStateMetas = <ButtonStateMeta>[
  ButtonStateMeta(
    label: 'Default',
    isEnabled: true,
    isLoading: false,
  ),
  ButtonStateMeta(
    label: 'Disabled',
    isEnabled: false,
    isLoading: false,
  ),
  ButtonStateMeta(
    label: 'Loading',
    isEnabled: true,
    isLoading: true,
  ),
];

String buttonTypeLabel(FitButtonType type) {
  return buttonTypeMetas.firstWhere((meta) => meta.type == type).label;
}

import 'fit_checkbox.dart';
import 'fit_checkbox_style.dart';

export 'fit_checkbox.dart';
export 'fit_checkbox_style.dart';

/// Deprecated: `FitCheckbox`를 사용하세요.
///
/// ```dart
/// // before
/// FitCheckBox(value: true, onChanged: (_) {});
///
/// // after
/// FitCheckbox(value: true, onChanged: (_) {});
/// ```
@Deprecated(
    'Use FitCheckbox instead. This alias will be removed in a major release.')
typedef FitCheckBox = FitCheckbox;

/// Deprecated: `FitCheckboxStyle`를 사용하세요.
@Deprecated(
  'Use FitCheckboxStyle instead. This alias will be removed in a major release.',
)
typedef FitCheckBoxStyle = FitCheckboxStyle;

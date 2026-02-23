import 'fit_checkbox_painter.dart';

export 'fit_checkbox_painter.dart';

/// Deprecated: `FitCheckboxPainter`를 사용하세요.
@Deprecated(
  'Use FitCheckboxPainter instead. This compatibility class will be removed in a major release.',
)
class CheckMarkPainter extends FitCheckboxPainter {
  const CheckMarkPainter({
    required super.progress,
    required super.color,
    required super.strokeWidth,
  });
}

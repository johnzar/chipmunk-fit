import 'package:flutter/material.dart';

/// 체크 마크를 progress(0.0~1.0)에 맞춰 그리는 painter입니다.
class FitCheckboxPainter extends CustomPainter {
  const FitCheckboxPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final firstStart = Offset(size.width * 0.25, size.height * 0.50);
    final firstEnd = Offset(size.width * 0.45, size.height * 0.70);
    final secondStart = firstEnd;
    final secondEnd = Offset(size.width * 0.75, size.height * 0.30);

    final path = Path();
    if (progress <= 0.5) {
      final local = progress * 2;
      path.moveTo(firstStart.dx, firstStart.dy);
      path.lineTo(
        firstStart.dx + (firstEnd.dx - firstStart.dx) * local,
        firstStart.dy + (firstEnd.dy - firstStart.dy) * local,
      );
    } else {
      path.moveTo(firstStart.dx, firstStart.dy);
      path.lineTo(firstEnd.dx, firstEnd.dy);

      final local = (progress - 0.5) * 2;
      path.moveTo(secondStart.dx, secondStart.dy);
      path.lineTo(
        secondStart.dx + (secondEnd.dx - secondStart.dx) * local,
        secondStart.dy + (secondEnd.dy - secondStart.dy) * local,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FitCheckboxPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

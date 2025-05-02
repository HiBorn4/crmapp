import 'dart:ui';
import 'package:flutter/material.dart';

class TaperedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double lineWidth = size.width * 0.85; // 60% of total width
    double startX = (size.width - lineWidth) / 2;

    for (double i = 0; i < lineWidth; i++) {
      double thickness = 4 * (1 - (2 * (i / lineWidth - 0.5)).abs());
      paint.strokeWidth = thickness.clamp(0, 3);
      canvas.drawPoints(
        PointMode.points,
        [Offset(startX + i, size.height / 2)],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

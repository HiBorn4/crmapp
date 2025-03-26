import 'dart:math';
import 'package:flutter/material.dart';

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = size.width * 0.12;
    final double radius = (size.width - strokeWidth) / 2.1;
    final double gapAngle = 2.2; // 2% of 360 degrees

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );

    // Calls - 40%
    _drawArc(canvas, rect, 25, Color(0xFFDBD3FD), startAngle: 180, strokeWidth: strokeWidth, gapAngle: gapAngle);
    // Tasks - 35%
    _drawArc(canvas, rect, 40, Color(0xFFFAC7C7), startAngle: -90, strokeWidth: strokeWidth, gapAngle: gapAngle);
    // Booked - 25%
    _drawArc(canvas, rect, 35, Color(0xFFC6FBC8), startAngle: 54, strokeWidth: strokeWidth, gapAngle: gapAngle);

    _drawCenterText(canvas, size);
  }

  void _drawArc(Canvas canvas, Rect rect, double percentage, Color color, 
               {double startAngle = 0, required double strokeWidth, required double gapAngle}) {
    final double adjustedSweepAngle = (percentage / 100) * 360 - gapAngle; // Reduce arc size for spacing
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // Make the ends square

    canvas.drawArc(
      rect,
      startAngle * (pi / 180), // Convert degrees to radians
      adjustedSweepAngle * (pi / 180), // Adjusted angle with gap
      false,
      paint,
    );
  }

  void _drawCenterText(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: size.width * 0.1,
      fontWeight: FontWeight.bold,
    );
    
    final textSpan = TextSpan(
      text: "Daily Goals\n50%",
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: size.width);
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

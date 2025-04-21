import 'dart:math' as math;
import 'package:flutter/material.dart';

class DonutChart extends StatelessWidget {
  final double paid;
  final double total;
  final double size;
  final Color paidColor;
  final Color eligibleColor;

  const DonutChart({
    required this.paid,
    required this.total,
    required this.size,
    required this.paidColor,
    required this.eligibleColor,
  });

  @override
Widget build(BuildContext context) {
  final bool isValid = total > 0;
  final int remainingBalance = isValid ? (total - paid).round() : 0;
  final int percentage = isValid ? ((paid / total) * 100).round() : 0;

  return SizedBox(
    width: size * 1.2,
    height: size * 1.2,
    child: Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(size, size),
          painter: _DonutChartPainter(
            paid: isValid ? paid : 0,
            total: isValid ? total : 1, // Prevent division by 0
            paidColor: paidColor,
            eligibleColor: eligibleColor,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$percentage%",
              style: TextStyle(
                fontSize: size * 0.16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

}

class _DonutChartPainter extends CustomPainter {
  final double paid;
  final double total;
  final Color paidColor;
  final Color eligibleColor;

  _DonutChartPainter({
    required this.paid,
    required this.total,
    required this.paidColor,
    required this.eligibleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = size.width * 0.2; // Increased thickness
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth) * 0.9;
    final double paidPercentage = paid / total;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // Keeps edges sharp

    // Draw remaining balance (Grey)
paint.color = Colors.grey[300]!;
canvas.drawCircle(center, radius, paint);

// Draw eligible balance (Lavender)
paint.color = Color(0XFFDBD3FD);
canvas.drawArc(
  Rect.fromCircle(center: center, radius: radius),
  -math.pi / 2,
  (1 - paidPercentage) * 2 * math.pi,
  false,
  paint,
);

// Draw paid arc (Main color)
if (paid > 0) {
  final double paidAngle = paidPercentage * 2 * math.pi;
  paint.color = paidColor;
  canvas.drawArc(
    Rect.fromCircle(center: center, radius: radius),
    -math.pi / 2, // Start from the top
    paidAngle,
    false,
    paint,
  );
}

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

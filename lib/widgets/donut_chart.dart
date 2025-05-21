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
    final int percentage = isValid ? ((paid / total) * 100).round() : 0;

    return SizedBox(
      width: size,
      height: size / 2,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          CustomPaint(
            size: Size(size, size / 2),
            painter: _SpeedometerPainter(
              paid: isValid ? paid : 0,
              total: isValid ? total : 1, // avoid div by 0
              paidColor: paidColor,
              eligibleColor: eligibleColor,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Text(
              "$percentage%",
              style: TextStyle(
                fontSize: size * 0.15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _SpeedometerPainter extends CustomPainter {
  final double paid;
  final double total;
  final Color paidColor;
  final Color eligibleColor;

  _SpeedometerPainter({
    required this.paid,
    required this.total,
    required this.paidColor,
    required this.eligibleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = size.height * 0.15; // Reduced thickness
    final Offset center = Offset(size.width / 2, size.height + strokeWidth / 2);
    final double radius = size.width / 1.4 - strokeWidth / 1.4; // Larger radius

    final double paidPercentage = paid / total;
    final double startAngle = math.pi; // 180 degrees (left)
    final double sweepAngle = math.pi; // 180 degrees (half circle)

    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw balance (grey) first - full semi-circle
    paint.color = eligibleColor;
    canvas.drawArc(arcRect, startAngle, sweepAngle, false, paint);

    // Draw paid (purple) arc
    paint.color = paidColor;
    canvas.drawArc(arcRect, startAngle, paidPercentage * sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

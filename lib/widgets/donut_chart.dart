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
    int remainingBalance = (total - paid).round(); // Convert to int (remove decimals)

    return SizedBox(
      width: size * 1.2, // Increase the total size of the donut
      height: size * 1.2, // Increase the total size of the donut
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutChartPainter(
              paid: paid,
              total: total,
              paidColor: paidColor,
              eligibleColor: eligibleColor,
            ),
          ),

          // Centered Balance Text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Balance",
                style: TextStyle(
                  fontSize: size * 0.1,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: size * 0.02),
              Text(
                "₹$remainingBalance", // Display as integer
                style: TextStyle(
                  fontSize: size * 0.12, // Increased balance font size
                  fontWeight: FontWeight.w900,
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
    final double strokeWidth = size.width * 0.25; // Increased thickness
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth) * 1.15;
    final double paidPercentage = paid / total;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // Keeps edges sharp

    // Draw remaining balance (Grey)
paint.color = Colors.grey[300]!;
canvas.drawCircle(center, radius, paint);

// Draw eligible balance (Lavender)
paint.color = Colors.purple[200]!;
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

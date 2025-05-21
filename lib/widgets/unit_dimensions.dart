import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A fully custom, pixel-perfect “plot orientation” diagram.
///
/// - D is the base dimension unit (here we scale it to your screen).
/// - `northIcon`, `southIcon`, etc. are Widgets you supply (e.g. Image.asset).
/// - `plotNo` and `adjacentPlotNo` get rendered at top and left.
///
class PlotOrientationDiagram extends StatelessWidget {
  final double D;
  final String plotNo;
  final String adjacentPlotNo;
  final Widget northIcon;
  final Widget southIcon;
  final Widget eastIcon;
  final Widget westIcon;
  final String roadLabel;

  const PlotOrientationDiagram({
    Key? key,
    required this.D,
    required this.plotNo,
    required this.adjacentPlotNo,
    required this.northIcon,
    required this.southIcon,
    required this.eastIcon,
    required this.westIcon,
    required this.roadLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Total width = 12.19 D + horizontal padding
    final width = 12.19 * D + 40;
    final height = 10.67 * D + 40;

    return SizedBox(
      width: width,
      height: height + 60, // extra for labels
      child: CustomPaint(
        painter: _PlotPainter(
          D: D,
          plotNo: plotNo,
          adjacentPlotNo: adjacentPlotNo,
          roadLabel: roadLabel,
        ),
        child: Stack(
          children: [
            // South icon at bottom center
            Positioned(
              left: width / 2 - D,
              top: (height - 2 * D) / 2 + D + 20,
              child: SizedBox(width: 2 * D, height: 2 * D, child: southIcon),
            ),

            // North icon at top center
            Positioned(
              left: width / 2 - D,
              top: 20 + (height - 2 * D) / 2 - 2 * D,
              child: SizedBox(width: 2 * D, height: 2 * D, child: northIcon),
            ),

            // East icon at center right
            Positioned(
              left: 12.19 * D + 20 - 2 * D,
              top: height / 2 - D + 20,
              child: SizedBox(width: 2 * D, height: 2 * D, child: eastIcon),
            ),

            // West icon at center left
            Positioned(
              left: 20,
              top: height / 2 - D + 20,
              child: SizedBox(width: 2 * D, height: 2 * D, child: westIcon),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlotPainter extends CustomPainter {
  final double D;
  final String plotNo;
  final String adjacentPlotNo;
  final String roadLabel;

  _PlotPainter({
    required this.D,
    required this.plotNo,
    required this.adjacentPlotNo,
    required this.roadLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 2;

    final dashPaint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 1;

    // Origin offset (20 px margin)
    final dx = 20.0, dy = 20.0;
    final w = 12.19 * D, h = 10.67 * D;

    // 1) Draw dashed rectangle
    final dashWidth = 8.0, dashSpace = 6.0;
    // top
    _drawDashedLine(canvas, Offset(dx, dy), Offset(dx + w, dy), dashPaint, dashWidth, dashSpace);
    // bottom
    _drawDashedLine(canvas, Offset(dx, dy + h), Offset(dx + w, dy + h), dashPaint, dashWidth, dashSpace);
    // left
    _drawDashedLine(canvas, Offset(dx, dy), Offset(dx, dy + h), dashPaint, dashWidth, dashSpace);
    // right
    _drawDashedLine(canvas, Offset(dx + w, dy), Offset(dx + w, dy + h), dashPaint, dashWidth, dashSpace);

    // 2) Arrows and dimension labels
    final textPainter = (String text) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: TextStyle(color: Colors.black, fontSize: D * 0.5)),
        textDirection: TextDirection.ltr,
      )..layout();
      return tp;
    };

    // Horizontal dimension (12.19 D)
    final midTop = Offset(dx + w / 2, dy - 10);
    final tpW = textPainter('${w.toStringAsFixed(2)} D');
    tpW.paint(canvas, midTop - Offset(tpW.width / 2, tpW.height));

    // vertical dimension (10.67 D)
    final midLeft = Offset(dx - 10, dy + h / 2);
    final tpH = textPainter('${h.toStringAsFixed(2)} D');
    // rotate vertical
    canvas.save();
    canvas.translate(midLeft.dx, midLeft.dy + tpH.width / 2);
    canvas.rotate(-math.pi / 2);
    tpH.paint(canvas, Offset(-tpH.width / 2, -tpH.height / 2));
    canvas.restore();

    // 3) Side labels (East, West, North, South)
    final sideTp = (String text) {
      final tp = TextPainter(
        text: TextSpan(text: text, style: TextStyle(color: Colors.grey[700], fontSize: D * 0.4)),
        textDirection: TextDirection.ltr,
      )..layout();
      return tp;
    };
    // Top (East)
    final tEast = sideTp('East');
    tEast.paint(canvas, Offset(dx + w / 2 - tEast.width / 2, dy - tEast.height - 20));
    // Bottom (West)
    final tWest = sideTp('West');
    tWest.paint(canvas, Offset(dx + w / 2 - tWest.width / 2, dy + h + 8));
    // Left (South)
    final tSouth = sideTp('South');
    canvas.save();
    canvas.translate(dx - tSouth.height - 20, dy + h / 2 + tSouth.width / 2);
    canvas.rotate(-math.pi / 2);
    tSouth.paint(canvas, Offset(-tSouth.width / 2, -tSouth.height / 2));
    canvas.restore();
    // Right (North)
    final tNorth = sideTp('North');
    canvas.save();
    canvas.translate(dx + w + 8, dy + h / 2 - tNorth.width / 2);
    canvas.rotate(math.pi / 2);
    tNorth.paint(canvas, Offset(-tNorth.width / 2, 0));
    canvas.restore();

    // 4) Plot numbers
    final plotTp = TextPainter(
      text: TextSpan(text: 'Plot no: $plotNo', style: TextStyle(fontSize: D * 0.5, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    plotTp.paint(canvas, Offset(dx + 10, dy - plotTp.height - 30));

    final adjTp = TextPainter(
      text: TextSpan(text: 'Plot no: $adjacentPlotNo', style: TextStyle(fontSize: D * 0.5, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    adjTp.paint(canvas, Offset(dx - adjTp.width - 30, dy + 10));
  }

  void _drawDashedLine(Canvas c, Offset a, Offset b, Paint p, double dashW, double dashS) {
    final total = (b - a).distance;
    final count = (total / (dashW + dashS)).floor();
    final vec = (b - a) / total;
    var start = a;
    for (int i = 0; i < count; i++) {
      c.drawLine(start, start + vec * dashW, p);
      start += vec * (dashW + dashS);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

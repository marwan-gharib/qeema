import 'package:flutter/material.dart';

class DivergingLinesPainter extends CustomPainter {
  DivergingLinesPainter({required this.nominalColor, required this.realColor});
  final Color nominalColor;
  final Color realColor;

  @override
  void paint(Canvas canvas, Size size) {
    final nominalPaint = Paint()
      ..color = nominalColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final realPaint = Paint()
      ..color = realColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    final nominalPath = Path();
    nominalPath.moveTo(0, h * 0.6);
    nominalPath.cubicTo(w * 0.3, h * 0.5, w * 0.6, h * 0.55, w, h * 0.3);
    canvas.drawPath(nominalPath, nominalPaint);

    final realPath = Path();
    realPath.moveTo(0, h * 0.65);
    realPath.cubicTo(w * 0.3, h * 0.7, w * 0.6, h * 0.75, w, h * 0.8);
    canvas.drawPath(realPath, realPaint);
  }

  @override
  bool shouldRepaint(covariant DivergingLinesPainter oldDelegate) =>
      oldDelegate.nominalColor != nominalColor ||
      oldDelegate.realColor != realColor;
}

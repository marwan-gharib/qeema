import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';

class WelcomeHeroIllustration extends StatelessWidget {
  const WelcomeHeroIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 200,
      height: 160,
      child: CustomPaint(
        size: const Size(200, 160),
        painter: _TrendMotifPainter(
          primary: colors.primary,
          secondary: colors.secondary,
        ),
      ),
    );
  }
}

class _TrendMotifPainter extends CustomPainter {
  _TrendMotifPainter({required this.primary, required this.secondary});
  final Color primary;
  final Color secondary;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final points = <Offset>[
      Offset(size.width * 0.1, size.height * 0.8),
      Offset(size.width * 0.3, size.height * 0.65),
      Offset(size.width * 0.45, size.height * 0.5),
      Offset(size.width * 0.65, size.height * 0.55),
      Offset(size.width * 0.85, size.height * 0.3),
      Offset(size.width * 0.95, size.height * 0.15),
    ];

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final mid = Offset((prev.dx + curr.dx) / 2, (prev.dy + curr.dy) / 2);
      path.quadraticBezierTo(prev.dx, prev.dy, mid.dx, mid.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);

    paint.color = primary.withValues(alpha: 0.6);
    canvas.drawPath(path, paint);

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          primary.withValues(alpha: 0.2),
          secondary.withValues(alpha: 0.2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fillPath = Path.from(path)
      ..lineTo(size.width * 0.95, size.height)
      ..lineTo(size.width * 0.1, size.height)
      ..close();
    canvas.drawPath(fillPath, fillPaint);

    const coinSize = 12.0;
    for (var i = 0; i < points.length; i++) {
      if (i == 0 || i == points.length - 1) continue;
      final coinPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = i.isEven ? primary : secondary;
      canvas.drawCircle(
        Offset(
          points[i].dx + size.width * 0.08 * (i - 2).toDouble(),
          points[i].dy - size.height * 0.15 * (i % 3 + 1),
        ),
        coinSize,
        coinPaint,
      );
      canvas.drawCircle(
        Offset(
          points[i].dx + size.width * 0.08 * (i - 2).toDouble(),
          points[i].dy - size.height * 0.15 * (i % 3 + 1),
        ),
        coinSize * 0.6,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.white.withValues(alpha: 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(_TrendMotifPainter oldDelegate) =>
      oldDelegate.primary != primary || oldDelegate.secondary != secondary;
}

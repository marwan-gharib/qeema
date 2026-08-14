import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/extensions/decimal_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';

class ErosionRing extends StatelessWidget {
  const ErosionRing({super.key, required this.erosionPercent});

  final Decimal erosionPercent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return RepaintBoundary(
      child: Column(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CustomPaint(
              painter: _ErosionRingPainter(
                erosionFraction: erosionPercent
                    .divideBy(Decimal.fromInt(100))
                    .toDouble(),
                trackColor: colors.divider,
                arcColor: colors.error,
              ),
              child: Center(
                child: Text(
                  '${erosionPercent.toStringAsFixed(1)}%',
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.t.home.erosionCaption,
            style: context.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErosionRingPainter extends CustomPainter {
  _ErosionRingPainter({
    required this.erosionFraction,
    required this.trackColor,
    required this.arcColor,
  });

  final double erosionFraction;
  final Color trackColor;
  final Color arcColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 10.0;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final sweepAngle = erosionFraction * 2 * math.pi;

    final arcPaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (sweepAngle > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ErosionRingPainter oldDelegate) =>
      oldDelegate.erosionFraction != erosionFraction;
}

import 'package:flutter/material.dart';
import 'package:qeema/features/onboarding/presentation/widgets/diverging_lines_painter.dart';

class InflationChartIllustration extends StatelessWidget {
  const InflationChartIllustration({
    super.key,
    required this.primary,
    required this.secondaryVariant,
  });
  final Color primary;
  final Color secondaryVariant;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 120,
      child: CustomPaint(
        painter: DivergingLinesPainter(
          nominalColor: primary,
          realColor: secondaryVariant,
        ),
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';

const double _parallaxFactor = 0.2;
const double _gradientRadiusBase = 0.8;
const double _gradientRadiusRange = 0.3;

class SplashBackground extends StatelessWidget {
  const SplashBackground({
    super.key,
    required this.breathValue,
    required this.rotationValue,
  });
  final double breathValue;
  final double rotationValue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final parallaxX = math.sin(rotationValue) * _parallaxFactor;
    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        gradient: RadialGradient(
          center: Alignment(parallaxX, 0),
          radius: _gradientRadiusBase + (breathValue * _gradientRadiusRange),
          colors: [colors.primary.withValues(alpha: 0.15), colors.background],
        ),
      ),
    );
  }
}

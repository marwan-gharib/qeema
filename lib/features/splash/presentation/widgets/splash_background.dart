import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';

const double _parallaxFactor = 0.2;
const double _gradientRadiusBase = 0.8;
const double _gradientRadiusRange = 0.3;

class SplashBackground extends StatelessWidget {
  const SplashBackground({
    super.key,
    required this.breathAnimation,
    required this.rotationYAnimation,
  });
  final Animation<double> breathAnimation;
  final Animation<double> rotationYAnimation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    return AnimatedBuilder(
      animation: Listenable.merge([breathAnimation, rotationYAnimation]),
      builder: (context, child) {
        final parallaxX = math.sin(rotationYAnimation.value) * _parallaxFactor;
        return Container(
          decoration: BoxDecoration(
            color: colors.background,
            gradient: RadialGradient(
              center: Alignment(parallaxX, 0),
              radius:
                  _gradientRadiusBase +
                  (breathAnimation.value * _gradientRadiusRange),
              colors: [
                colors.primary.withValues(alpha: 0.15),
                colors.background,
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';

const double _ringSize = 130.0;

class LogoEnergyRing extends StatelessWidget {
  const LogoEnergyRing({
    super.key,
    required this.rotationAnimation,
    required this.isReducedMotion,
  });
  final Animation<double> rotationAnimation;
  final bool isReducedMotion;

  @override
  Widget build(BuildContext context) {
    if (isReducedMotion) return const SizedBox.shrink();
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    return AnimatedBuilder(
      animation: rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: rotationAnimation.value * 2 * math.pi,
          child: Container(
            width: _ringSize,
            height: _ringSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  colors.primary.withValues(alpha: 0.0),
                  colors.primaryVariant.withValues(alpha: 0.5),
                  colors.primary.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }
}

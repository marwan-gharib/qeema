import 'package:flutter/material.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';

const double _glowSize = 120.0;
const double _pulseMaxSpread = 60.0;
const double _pulseMaxBlur = 30.0;

class LogoPulseGlow extends StatelessWidget {
  const LogoPulseGlow({super.key, required this.pulseAnimation});
  final Animation<double> pulseAnimation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        final pulseAlpha = 1.0 - pulseAnimation.value;
        return Container(
          width: _glowSize,
          height: _glowSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colors.secondaryVariant.withValues(alpha: pulseAlpha),
                spreadRadius: pulseAnimation.value * _pulseMaxSpread,
                blurRadius: pulseAnimation.value * _pulseMaxBlur,
              ),
            ],
          ),
        );
      },
    );
  }
}

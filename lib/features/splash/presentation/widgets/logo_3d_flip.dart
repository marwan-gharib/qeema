import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:qeema/core/constants/app_assets.dart';

const double _logoSize = 160.0;
const double _shadowOffsetFactor = 20.0;
const double _shadowBlurFactor = 30.0;
const double _shadowAlpha = 0.3;

class Logo3DFlip extends StatelessWidget {
  const Logo3DFlip({
    super.key,
    required this.logoRotationY,
    required this.logoScale,
    required this.logoOpacity,
  });
  final Animation<double> logoRotationY;
  final Animation<double> logoScale;
  final Animation<double> logoOpacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([logoRotationY, logoScale, logoOpacity]),
      builder: (context, child) {
        final shadowOffset =
            math.sin(logoRotationY.value) * _shadowOffsetFactor;
        final shadowBlur = math.sin(logoRotationY.value) * _shadowBlurFactor;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(logoRotationY.value),
          child: Transform.scale(
            scale: logoScale.value,
            child: Opacity(
              opacity: logoOpacity.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (shadowOffset > 0.01)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: _shadowAlpha),
                        offset: Offset(shadowOffset, shadowOffset),
                        blurRadius: shadowBlur,
                      ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
        );
      },
      child: ClipOval(
        child: Image.asset(
          AppAssets.qeemaLogo,
          width: _logoSize,
          height: _logoSize,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

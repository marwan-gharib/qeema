import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/constants/app_assets.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';

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
  final double logoRotationY;
  final double logoScale;
  final double logoOpacity;

  @override
  Widget build(BuildContext context) {
    final shadowColor = context.colors.shadow;
    final shadowOffset = math.sin(logoRotationY) * _shadowOffsetFactor;
    final shadowBlur = math.sin(logoRotationY) * _shadowBlurFactor;
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(logoRotationY),
      child: Transform.scale(
        scale: logoScale,
        child: Opacity(
          opacity: logoOpacity,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                if (shadowOffset > 0.01)
                  BoxShadow(
                    color: shadowColor.withValues(alpha: _shadowAlpha),
                    offset: Offset(shadowOffset, shadowOffset),
                    blurRadius: shadowBlur,
                  ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                AppAssets.qeemaLogo,
                width: _logoSize,
                height: _logoSize,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

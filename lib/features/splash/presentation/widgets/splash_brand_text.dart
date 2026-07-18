import 'package:flutter/material.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';

const double _brandLetterSpacing = 1.2;

class SplashBrandText extends StatelessWidget {
  const SplashBrandText({
    super.key,
    required this.textOpacity,
    required this.textSlide,
    required this.textScale,
    required this.appName,
    required this.tagline,
  });
  final Animation<double> textOpacity;
  final Animation<Offset> textSlide;
  final Animation<double> textScale;
  final String appName;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final textTheme = Theme.of(context).textTheme;
    return AnimatedBuilder(
      animation: Listenable.merge([textOpacity, textSlide, textScale]),
      builder: (context, child) {
        return Transform.scale(
          scale: textScale.value,
          child: SlideTransition(
            position: textSlide,
            child: Opacity(opacity: textOpacity.value, child: child),
          ),
        );
      },
      child: Column(
        children: [
          Text(
            appName,
            style: textTheme.headlineLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
              letterSpacing: _brandLetterSpacing,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            tagline,
            style: textTheme.titleLarge?.copyWith(
              color: colors.primaryVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

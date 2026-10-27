import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/core/theme/app_spacing.dart';

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
  final double textOpacity;
  final Offset textSlide;
  final double textScale;
  final String appName;
  final String tagline;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final textTheme = Theme.of(context).textTheme;
    return Transform.scale(
      scale: textScale,
      child: FractionalTranslation(
        translation: textSlide,
        child: Opacity(
          opacity: textOpacity,
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
              SizedBox(height: AppSpacing.xs),
              Text(
                tagline,
                style: textTheme.titleLarge?.copyWith(
                  color: colors.primaryVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

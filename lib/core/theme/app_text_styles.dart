import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_text_theme.dart';

/// Named text styles that have no fitting [TextTheme] slot.
///
/// Registered on [ThemeData.extensions] by [AppTheme] and read through
/// `context.textStyles`.
class AppTextStylesExtension extends ThemeExtension<AppTextStylesExtension> {
  const AppTextStylesExtension({
    required this.chartAxisLabel,
    required this.caratBadge,
    required this.footnote,
    required this.onboardingHeadline,
  });

  factory AppTextStylesExtension.defaults() {
    final textTheme = AppTextTheme.textTheme;
    return AppTextStylesExtension(
      chartAxisLabel: textTheme.bodySmall!.copyWith(
        fontSize: Responsive.font(10),
      ),
      caratBadge: textTheme.bodySmall!.copyWith(
        fontSize: Responsive.font(10),
        fontWeight: FontWeight.bold,
      ),
      footnote: textTheme.bodySmall!.copyWith(fontSize: Responsive.font(11)),
      onboardingHeadline: textTheme.displayLarge!.copyWith(
        fontSize: Responsive.font(26),
      ),
    );
  }

  /// Chart tick labels: body text weight at a size below `bodySmall`.
  final TextStyle chartAxisLabel;

  /// 21K/24K carat badge on gold tiles.
  final TextStyle caratBadge;

  /// Secondary footnote one step below `bodySmall`.
  final TextStyle footnote;

  /// Onboarding headline: `displayLarge` weight at its own size.
  final TextStyle onboardingHeadline;

  @override
  AppTextStylesExtension copyWith({
    TextStyle? chartAxisLabel,
    TextStyle? caratBadge,
    TextStyle? footnote,
    TextStyle? onboardingHeadline,
  }) {
    return AppTextStylesExtension(
      chartAxisLabel: chartAxisLabel ?? this.chartAxisLabel,
      caratBadge: caratBadge ?? this.caratBadge,
      footnote: footnote ?? this.footnote,
      onboardingHeadline: onboardingHeadline ?? this.onboardingHeadline,
    );
  }

  @override
  AppTextStylesExtension lerp(
    ThemeExtension<AppTextStylesExtension>? other,
    double t,
  ) {
    if (other is! AppTextStylesExtension) return this;
    return AppTextStylesExtension(
      chartAxisLabel:
          TextStyle.lerp(chartAxisLabel, other.chartAxisLabel, t) ??
          chartAxisLabel,
      caratBadge: TextStyle.lerp(caratBadge, other.caratBadge, t) ?? caratBadge,
      footnote: TextStyle.lerp(footnote, other.footnote, t) ?? footnote,
      onboardingHeadline:
          TextStyle.lerp(onboardingHeadline, other.onboardingHeadline, t) ??
          onboardingHeadline,
    );
  }
}

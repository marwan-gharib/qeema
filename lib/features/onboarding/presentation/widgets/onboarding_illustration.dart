import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/features/onboarding/presentation/widgets/asset_tracking_illustration.dart';
import 'package:qeema/features/onboarding/presentation/widgets/get_started_illustration.dart';
import 'package:qeema/features/onboarding/presentation/widgets/inflation_chart_illustration.dart';
import 'package:qeema/features/onboarding/presentation/widgets/money_value_illustration.dart';

enum OnboardingIllustrationType {
  moneyValue,
  assetTracking,
  inflationChart,
  getStarted,
}

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({super.key, required this.type});
  final OnboardingIllustrationType type;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return switch (type) {
      OnboardingIllustrationType.moneyValue => MoneyValueIllustration(
        primary: colors.primary,
        primaryVariant: colors.primaryVariant,
        error: colors.error,
        textSecondary: colors.textSecondary,
        iconColor: colors.onPrimary,
      ),
      OnboardingIllustrationType.assetTracking => AssetTrackingIllustration(
        primary: colors.primary,
        primaryVariant: colors.primaryVariant,
        secondary: colors.secondary,
      ),
      OnboardingIllustrationType.inflationChart => InflationChartIllustration(
        primary: colors.primary,
        secondaryVariant: colors.secondaryVariant,
      ),
      OnboardingIllustrationType.getStarted => GetStartedIllustration(
        secondary: colors.secondary,
        secondaryVariant: colors.secondaryVariant,
        iconColor: colors.onPrimary,
      ),
    };
  }
}

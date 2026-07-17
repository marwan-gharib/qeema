import 'package:flutter/material.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/onboarding/presentation/widgets/asset_icon.dart';

class AssetTrackingIllustration extends StatelessWidget {
  const AssetTrackingIllustration({
    super.key,
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
  });
  final Color primary;
  final Color primaryVariant;
  final Color secondary;

  @override
  Widget build(BuildContext context) {
    final t = context.t.onboarding.assetType;
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.md,
      alignment: WrapAlignment.center,
      children: [
        AssetIcon(icon: Icons.money, label: t.egp, color: primary),
        AssetIcon(
          icon: Icons.attach_money,
          label: t.usd,
          color: primaryVariant,
        ),
        AssetIcon(icon: Icons.star, label: t.gold, color: secondary),
      ],
    );
  }
}

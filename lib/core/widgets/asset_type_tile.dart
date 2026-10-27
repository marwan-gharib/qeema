import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/constants/asset_type_codes.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_sizes.dart';
import 'package:qeema/core/theme/app_spacing.dart';

/// A selectable tile for an asset type, identified by its [code]. Shared by the
/// assets picker and market prices (WIDGET-3); the display name and carat badge
/// are localized from the code via core i18n.
class AssetTypeTile extends StatelessWidget {
  const AssetTypeTile({
    super.key,
    required this.code,
    required this.isSelected,
  });

  final String code;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          _buildIconWithBadge(context),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              context.assetTypeName(code),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : null,
              ),
            ),
          ),
          if (isSelected)
            Icon(
              Icons.check_circle,
              color: colors.primary,
              size: AppSizes.iconStandard,
            ),
        ],
      ),
    );
  }

  Widget _buildIconWithBadge(BuildContext context) {
    final colors = context.colors;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          iconForType(code),
          size: AppSizes.iconLarge,
          color: colors.textPrimary,
        ),
        if (code.startsWith(AssetTypeCodes.goldPrefix))
          Positioned(
            right: Responsive.width(-10),
            top: Responsive.height(-6),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xxs,
                vertical: Responsive.adapt(1),
              ),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(AppRadius.xxs),
              ),
              child: Text(
                code == AssetTypeCodes.gold21
                    ? context.t.assets.carat.k21
                    : context.t.assets.carat.k24,
                style: context.textStyles.caratBadge.copyWith(
                  color: colors.onPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  static IconData iconForType(String code) {
    switch (code) {
      case AssetTypeCodes.cashEgp:
        return Icons.payments_outlined;
      case AssetTypeCodes.usd:
        return Icons.attach_money;
      case AssetTypeCodes.gold21:
      case AssetTypeCodes.gold24:
        return Icons.monetization_on_outlined;
      default:
        return Icons.account_balance_outlined;
    }
  }
}

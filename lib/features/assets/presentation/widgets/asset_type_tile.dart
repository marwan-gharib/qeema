import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_sizes.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';

class AssetTypeTile extends StatelessWidget {
  const AssetTypeTile({
    super.key,
    required this.type,
    required this.isSelected,
  });

  final AssetTypeEntity type;
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
              context.assetTypeName(type.code),
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
          iconForType(type.code),
          size: AppSizes.iconLarge,
          color: colors.textPrimary,
        ),
        if (type.code.startsWith('gold_'))
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
                type.code == 'gold_21' ? '21K' : '24K',
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
      case 'cash_egp':
        return Icons.payments_outlined;
      case 'usd':
        return Icons.attach_money;
      case 'gold_21':
      case 'gold_24':
        return Icons.monetization_on_outlined;
      default:
        return Icons.account_balance_outlined;
    }
  }
}

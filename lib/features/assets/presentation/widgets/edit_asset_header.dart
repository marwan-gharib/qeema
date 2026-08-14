import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';

class EditAssetHeader extends StatelessWidget {
  const EditAssetHeader({
    super.key,
    required this.asset,
    required this.typeEntity,
  });

  final AssetEntity asset;
  final AssetTypeEntity typeEntity;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(_iconForType(asset.assetType), size: 24, color: colors.primary),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t.assets.edit.assetTypeLabel,
                style: context.textTheme.labelSmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              Text(
                typeEntity.name,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _iconForType(AssetType type) {
    switch (type) {
      case AssetType.egpCash:
        return Icons.payments_outlined;
      case AssetType.usdCash:
        return Icons.attach_money;
      case AssetType.gold21:
      case AssetType.gold24:
        return Icons.monetization_on_outlined;
    }
  }
}

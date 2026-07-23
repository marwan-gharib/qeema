import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/financial/asset_valuator.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

class AssetListItem extends StatelessWidget {
  const AssetListItem({
    super.key,
    required this.asset,
    this.valuator,
    this.currentUnitPrice,
    this.onTap,
  });
  final AssetEntity asset;
  final AssetValuator? valuator;
  final double? currentUnitPrice;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        title: Text(
          asset.assetTypeCode.toUpperCase(),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${asset.amount.toStringAsFixed(4)} ${asset.assetTypeCode.toUpperCase()}',
          style: context.textTheme.bodySmall,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${asset.priceAtEntry.toStringAsFixed(2)} EGP',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

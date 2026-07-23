import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_history_timeline.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_value_chart.dart';

class AssetDetailScreen extends StatelessWidget {
  const AssetDetailScreen({
    super.key,
    required this.asset,
    this.history = const [],
  });
  final AssetEntity asset;
  final List<AssetHistoryEntryEntity> history;

  @override
  Widget build(BuildContext context) {
    final isCashType = asset.assetTypeCode == 'cash_egp';

    return Scaffold(
      appBar: AppBar(
        title: Text(asset.assetTypeCode.toUpperCase()),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              context.pushNamed(
                RouteNames.editAsset,
                pathParameters: {'assetId': asset.id},
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${asset.amount.toStringAsFixed(4)} ${asset.assetTypeCode.toUpperCase()}',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.t.assets.detail.entryPrice.replaceAll(
                      '{price}',
                      asset.priceAtEntry.toStringAsFixed(2),
                    ),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.t.assets.detail.valueTrend,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          AssetValueChart(
            isFlat: isCashType,
            entryValue: asset.priceAtEntry.toDouble(),
          ),
          const SizedBox(height: 24),
          Text(
            context.t.assets.detail.editHistory,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          AssetHistoryTimeline(entries: history),
        ],
      ),
    );
  }
}

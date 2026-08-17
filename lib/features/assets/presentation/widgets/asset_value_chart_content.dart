import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_empty_state.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/presentation/widgets/cash_flat_chart.dart';
import 'package:qeema/features/assets/presentation/widgets/market_price_chart.dart';

class AssetValueChartBody extends StatelessWidget {
  const AssetValueChartBody({
    super.key,
    required this.asset,
    this.priceHistory,
  });

  final AssetEntity asset;
  final List<MarketPriceEntity>? priceHistory;

  @override
  Widget build(BuildContext context) {
    if (asset.assetType == AssetType.egpCash) {
      return CashFlatChart(asset: asset);
    }

    if (priceHistory == null || priceHistory!.length < 2) {
      final t = context.t.assets.chart;
      return AppEmptyState(
        icon: Icons.show_chart,
        title: t.noDataTitle,
        subtitle: t.noDataSubtitle,
        container: true,
        height: 250,
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
      );
    }

    return MarketPriceChart(priceHistory: priceHistory!);
  }
}

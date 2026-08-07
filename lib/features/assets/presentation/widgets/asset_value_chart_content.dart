import 'package:flutter/material.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/presentation/widgets/cash_flat_chart.dart';
import 'package:qeema/features/assets/presentation/widgets/chart_not_enough_data.dart';
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
      return const ChartNotEnoughData();
    }

    return MarketPriceChart(priceHistory: priceHistory!);
  }
}

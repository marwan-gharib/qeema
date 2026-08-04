import 'package:flutter/material.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_value_chart_content.dart';

class AssetValueChart extends StatelessWidget {
  const AssetValueChart({super.key, required this.asset, this.priceHistory});

  final AssetEntity asset;
  final List<double>? priceHistory;

  @override
  Widget build(BuildContext context) {
    return AssetValueChartBody(asset: asset, priceHistory: priceHistory);
  }
}

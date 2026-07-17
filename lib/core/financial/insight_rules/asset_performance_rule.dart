import 'package:qeema/core/financial/insight_rules/insight_rule.dart';
import 'package:qeema/core/financial/models/asset_in_base_currency.dart';
import 'package:qeema/core/financial/models/insight.dart';
import 'package:qeema/core/financial/models/insight_severity.dart';
import 'package:qeema/core/financial/models/insight_type.dart';
import 'package:qeema/core/financial/models/portfolio_snapshot_data.dart';

class AssetPerformanceRule implements InsightRule {
  @override
  List<Insight> evaluate({
    required PortfolioSnapshotData currentSnapshot,
    required List<AssetInBaseCurrency> assets,
  }) {
    if (assets.length < 2) return [];

    final sorted = List<AssetInBaseCurrency>.from(assets)
      ..sort((a, b) => a.valueInBaseCurrency.compareTo(b.valueInBaseCurrency));
    final best = sorted.last;

    return [
      Insight(
        title: 'Best performing asset',
        body:
            'Asset ${best.sourceAssetId} leads your portfolio with a value of ${best.valueInBaseCurrency.toStringAsFixed(2)} EGP.',
        type: InsightType.assetPerformance,
        severity: InsightSeverity.info,
      ),
    ];
  }
}

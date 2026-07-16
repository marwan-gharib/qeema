import 'package:decimal/decimal.dart';

import '../models/asset_in_base_currency.dart';
import '../models/insight.dart';
import '../models/portfolio_snapshot_data.dart';
import 'insight_rule.dart';

class InflationLossRule implements InsightRule {
  final Decimal _threshold;
  InflationLossRule({Decimal? threshold})
    : _threshold = threshold ?? Decimal.fromInt(10);

  Decimal _d(dynamic v) => Decimal.parse(v.toString());

  @override
  List<Insight> evaluate({
    required PortfolioSnapshotData currentSnapshot,
    required List<AssetInBaseCurrency> assets,
  }) {
    if (currentSnapshot.nominalValue == Decimal.zero) return [];

    final ratio = _d(
      (currentSnapshot.nominalValue - currentSnapshot.realValue) /
          currentSnapshot.nominalValue,
    );
    final erosion = _d(ratio * Decimal.fromInt(100));

    if (erosion > _threshold) {
      return [
        Insight(
          title: 'Inflation erosion detected',
          body:
              'Your money has lost ${erosion.toStringAsFixed(1)}% of its purchasing power since you started tracking.',
          type: InsightType.inflationLoss,
          severity: erosion > Decimal.fromInt(25)
              ? InsightSeverity.attention
              : InsightSeverity.info,
        ),
      ];
    }
    return [];
  }
}

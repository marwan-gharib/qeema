import 'package:decimal/decimal.dart';
import 'package:qeema/core/financial/insight_rules/insight_rule.dart';
import 'package:qeema/core/financial/models/asset_in_base_currency.dart';
import 'package:qeema/core/financial/models/insight.dart';
import 'package:qeema/core/financial/models/insight_severity.dart';
import 'package:qeema/core/financial/models/insight_type.dart';
import 'package:qeema/core/financial/models/portfolio_snapshot_data.dart';

class InflationLossRule implements InsightRule {
  InflationLossRule({Decimal? threshold})
    : _threshold = threshold ?? Decimal.fromInt(10);
  final Decimal _threshold;

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

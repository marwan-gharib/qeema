import 'package:decimal/decimal.dart';
import 'package:qeema/core/financial/insight_rules/insight_rule.dart';
import 'package:qeema/core/financial/models/asset_in_base_currency.dart';
import 'package:qeema/core/financial/models/insight.dart';
import 'package:qeema/core/financial/models/insight_severity.dart';
import 'package:qeema/core/financial/models/insight_type.dart';
import 'package:qeema/core/financial/models/portfolio_snapshot_data.dart';

class ConcentrationRiskRule implements InsightRule {
  ConcentrationRiskRule({Decimal? threshold})
    : _threshold = threshold ?? Decimal.parse('0.8');
  final Decimal _threshold;

  Decimal _d(dynamic v) => Decimal.parse(v.toString());

  @override
  List<Insight> evaluate({
    required PortfolioSnapshotData currentSnapshot,
    required List<AssetInBaseCurrency> assets,
  }) {
    if (currentSnapshot.nominalValue == Decimal.zero || assets.isEmpty) {
      return [];
    }

    for (final asset in assets) {
      final share = _d(
        asset.valueInBaseCurrency / currentSnapshot.nominalValue,
      );
      if (share > _threshold) {
        return [
          const Insight(
            title: 'High concentration risk',
            body:
                'Over 80% of your portfolio is in one asset type. Consider diversifying to reduce risk.',
            type: InsightType.concentrationRisk,
            severity: InsightSeverity.attention,
          ),
        ];
      }
    }
    return [];
  }
}

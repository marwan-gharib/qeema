import 'package:decimal/decimal.dart';

import '../models/asset_in_base_currency.dart';
import '../models/insight.dart';
import '../models/portfolio_snapshot_data.dart';
import 'insight_rule.dart';

class ConcentrationRiskRule implements InsightRule {
  final Decimal _threshold;
  ConcentrationRiskRule({Decimal? threshold})
    : _threshold = threshold ?? Decimal.parse('0.8');

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
          Insight(
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

import '../models/asset_in_base_currency.dart';
import '../models/insight.dart';
import '../models/portfolio_snapshot_data.dart';
import 'insight_rule.dart';

class GoalFeasibilityRule implements InsightRule {
  @override
  List<Insight> evaluate({
    required PortfolioSnapshotData currentSnapshot,
    required List<AssetInBaseCurrency> assets,
  }) {
    return [
      Insight(
        title: 'Savings goal check',
        body:
            'At the current pace of inflation, your savings goals may need to be revised upward to maintain their real value.',
        type: InsightType.goalFeasibility,
        severity: InsightSeverity.info,
      ),
    ];
  }
}

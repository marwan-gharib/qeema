import 'package:qeema/core/financial/insight_rules/insight_rule.dart';
import 'package:qeema/core/financial/models/asset_in_base_currency.dart';
import 'package:qeema/core/financial/models/insight.dart';
import 'package:qeema/core/financial/models/insight_severity.dart';
import 'package:qeema/core/financial/models/insight_type.dart';
import 'package:qeema/core/financial/models/portfolio_snapshot_data.dart';

class GoalFeasibilityRule implements InsightRule {
  @override
  List<Insight> evaluate({
    required PortfolioSnapshotData currentSnapshot,
    required List<AssetInBaseCurrency> assets,
  }) {
    return [
      const Insight(
        title: 'Savings goal check',
        body:
            'At the current pace of inflation, your savings goals may need to be revised upward to maintain their real value.',
        type: InsightType.goalFeasibility,
        severity: InsightSeverity.info,
      ),
    ];
  }
}

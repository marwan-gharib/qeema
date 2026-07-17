import 'package:qeema/core/financial/insight_rules/insight_rule.dart';
import 'package:qeema/core/financial/models/asset_in_base_currency.dart';
import 'package:qeema/core/financial/models/insight.dart';
import 'package:qeema/core/financial/models/portfolio_snapshot_data.dart';

class FinancialInsightEngine {
  const FinancialInsightEngine(this._rules);
  final List<InsightRule> _rules;

  List<Insight> generate({
    required PortfolioSnapshotData currentSnapshot,
    required List<AssetInBaseCurrency> assets,
  }) {
    final insights = _rules
        .expand(
          (rule) =>
              rule.evaluate(currentSnapshot: currentSnapshot, assets: assets),
        )
        .toList();
    insights.sort((a, b) => b.severity.index.compareTo(a.severity.index));
    return insights;
  }
}

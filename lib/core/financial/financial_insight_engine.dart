import 'insight_rules/insight_rule.dart';
import 'models/asset_in_base_currency.dart';
import 'models/insight.dart';
import 'models/portfolio_snapshot_data.dart';

class FinancialInsightEngine {
  final List<InsightRule> _rules;
  const FinancialInsightEngine(this._rules);

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

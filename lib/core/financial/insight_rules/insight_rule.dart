import '../models/asset_in_base_currency.dart';
import '../models/insight.dart';
import '../models/portfolio_snapshot_data.dart';

abstract class InsightRule {
  List<Insight> evaluate({
    required PortfolioSnapshotData currentSnapshot,
    required List<AssetInBaseCurrency> assets,
  });
}

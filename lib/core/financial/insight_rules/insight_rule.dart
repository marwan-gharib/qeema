import 'package:qeema/core/financial/models/asset_in_base_currency.dart';
import 'package:qeema/core/financial/models/insight.dart';
import 'package:qeema/core/financial/models/portfolio_snapshot_data.dart';

abstract class InsightRule {
  List<Insight> evaluate({
    required PortfolioSnapshotData currentSnapshot,
    required List<AssetInBaseCurrency> assets,
  });
}

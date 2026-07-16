import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/cached_asset_history_table.dart';
import 'tables/cached_asset_types_table.dart';
import 'tables/cached_assets_table.dart';
import 'tables/cached_inflation_rates_table.dart';
import 'tables/cached_market_prices_table.dart';
import 'tables/cached_portfolio_snapshots_table.dart';
import 'tables/cached_savings_goals_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CachedAssetsTable,
    CachedAssetHistoryTable,
    CachedMarketPricesTable,
    CachedInflationRatesTable,
    CachedPortfolioSnapshotsTable,
    CachedSavingsGoalsTable,
    CachedAssetTypesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'qeema_cache.db'));
    return NativeDatabase.createInBackground(file);
  });
}

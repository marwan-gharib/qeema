import 'package:drift/drift.dart';

import '../app_database.dart';

class MarketPricesDao {
  final AppDatabase _db;
  const MarketPricesDao(this._db);

  Future<List<CachedMarketPricesTableData>> getAll() async {
    return await _db.select(_db.cachedMarketPricesTable).get();
  }

  Future<CachedMarketPricesTableData?> latestForType(
    String assetTypeCode,
  ) async {
    return await (_db.select(_db.cachedMarketPricesTable)
          ..where((t) => t.assetTypeCode.equals(assetTypeCode))
          ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> insertOrUpdate(CachedMarketPricesTableCompanion entry) async {
    await _db.into(_db.cachedMarketPricesTable).insertOnConflictUpdate(entry);
  }

  Future<void> clear() async {
    await _db.delete(_db.cachedMarketPricesTable).go();
  }
}

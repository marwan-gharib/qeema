import 'package:drift/drift.dart';
import 'package:qeema/core/local/cache/app_database.dart';

class MarketPricesDao {
  const MarketPricesDao(this._db);
  final AppDatabase _db;

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

import 'package:drift/drift.dart';
import 'package:qeema/core/local/cache/app_database.dart';

class AssetHistoryDao {
  const AssetHistoryDao(this._db);
  final AppDatabase _db;

  Future<List<CachedAssetHistoryTableData>> getForAsset(String assetId) async {
    return await (_db.select(_db.cachedAssetHistoryTable)
          ..where((t) => t.assetId.equals(assetId))
          ..orderBy([(t) => OrderingTerm.desc(t.changedAt)]))
        .get();
  }

  Future<void> insertOrUpdate(CachedAssetHistoryTableCompanion entry) async {
    await _db.into(_db.cachedAssetHistoryTable).insertOnConflictUpdate(entry);
  }

  Future<void> clearForAsset(String assetId) async {
    await (_db.delete(
      _db.cachedAssetHistoryTable,
    )..where((t) => t.assetId.equals(assetId))).go();
  }
}

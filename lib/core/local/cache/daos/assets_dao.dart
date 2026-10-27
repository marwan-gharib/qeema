import 'package:qeema/core/local/cache/app_database.dart';

class AssetsDao {
  const AssetsDao(this._db);
  final AppDatabase _db;

  Future<List<CachedAssetsTableData>> getActiveAssets(String userId) async {
    return await (_db.select(
      _db.cachedAssetsTable,
    )..where((t) => t.userId.equals(userId))).get();
  }

  Future<void> insertOrUpdate(CachedAssetsTableCompanion entry) async {
    await _db.into(_db.cachedAssetsTable).insertOnConflictUpdate(entry);
  }

  Future<void> deleteById(String id) async {
    await (_db.delete(
      _db.cachedAssetsTable,
    )..where((t) => t.id.equals(id))).go();
  }

  /// Replaces the whole cache with [entries] in one atomic batch — after a
  /// successful fetch the cached mirror must match the server list exactly
  /// (no stale rows from earlier sessions).
  Future<void> replaceAll(List<CachedAssetsTableCompanion> entries) async {
    await _db.batch((batch) {
      batch.deleteAll(_db.cachedAssetsTable);
      batch.insertAll(_db.cachedAssetsTable, entries);
    });
  }
}

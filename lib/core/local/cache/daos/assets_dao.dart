import 'package:drift/drift.dart';

import '../app_database.dart';

class AssetsDao {
  final AppDatabase _db;
  const AssetsDao(this._db);

  Future<List<CachedAssetsTableData>> watchActiveAssets(String userId) async {
    return await (_db.select(
      _db.cachedAssetsTable,
    )..where((t) => t.userId.equals(userId))).get();
  }

  Future<void> insertOrUpdate(CachedAssetsTableCompanion entry) async {
    await _db.into(_db.cachedAssetsTable).insertOnConflictUpdate(entry);
  }

  Future<void> markPendingSync(String id) async {
    await (_db.update(_db.cachedAssetsTable)..where((t) => t.id.equals(id)))
        .write(const CachedAssetsTableCompanion(pendingSync: Value(true)));
  }

  Future<void> deleteById(String id) async {
    await (_db.delete(
      _db.cachedAssetsTable,
    )..where((t) => t.id.equals(id))).go();
  }

  Future<List<CachedAssetsTableData>> pendingSyncItems() async {
    return await (_db.select(
      _db.cachedAssetsTable,
    )..where((t) => t.pendingSync.equals(true))).get();
  }
}

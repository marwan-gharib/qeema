import 'package:drift/drift.dart';
import 'package:qeema/core/local/cache/app_database.dart';

class AssetsDao {
  const AssetsDao(this._db);
  final AppDatabase _db;

  Stream<List<CachedAssetsTableData>> watchActiveAssets(String userId) {
    return (_db.select(
      _db.cachedAssetsTable,
    )..where((t) => t.userId.equals(userId))).watch();
  }

  Future<List<CachedAssetsTableData>> getActiveAssets(String userId) async {
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

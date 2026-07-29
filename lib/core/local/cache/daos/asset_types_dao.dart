import 'package:qeema/core/local/cache/app_database.dart';

class AssetTypesDao {
  const AssetTypesDao(this._db);
  final AppDatabase _db;

  Future<List<CachedAssetTypesTableData>> getAll() async {
    return await _db.select(_db.cachedAssetTypesTable).get();
  }

  Future<void> insertOrUpdate(CachedAssetTypesTableCompanion entry) async {
    await _db.into(_db.cachedAssetTypesTable).insertOnConflictUpdate(entry);
  }

  Future<void> clear() async {
    await _db.delete(_db.cachedAssetTypesTable).go();
  }
}

import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/local/cache/daos/assets_dao.dart';

class MockAssetsDao implements AssetsDao {
  bool shouldThrow = false;

  @override
  Future<void> deleteById(String id) async {}

  @override
  Future<List<CachedAssetsTableData>> getActiveAssets(String userId) async =>
      [];

  @override
  Future<void> insertOrUpdate(CachedAssetsTableCompanion entry) async {
    if (shouldThrow) throw Exception('mock dao error');
  }

  @override
  Future<void> markPendingSync(String id) async {}

  @override
  Future<List<CachedAssetsTableData>> pendingSyncItems() async => [];

  @override
  Stream<List<CachedAssetsTableData>> watchActiveAssets(String userId) =>
      const Stream.empty();
}

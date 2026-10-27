import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/local/cache/daos/assets_dao.dart';

/// In-memory fake of the drift cache so repository tests can exercise the
/// offline-first mirror without a real database.
class MockAssetsDao implements AssetsDao {
  bool shouldThrow = false;
  final List<CachedAssetsTableData> rows = [];

  @override
  Future<List<CachedAssetsTableData>> getActiveAssets(String userId) async {
    if (shouldThrow) throw Exception('mock dao error');
    return rows.where((row) => row.userId == userId).toList();
  }

  @override
  Future<void> insertOrUpdate(CachedAssetsTableCompanion entry) async {
    if (shouldThrow) throw Exception('mock dao error');
    final data = _resolve(entry);
    rows.removeWhere((row) => row.id == data.id);
    rows.add(data);
  }

  @override
  Future<void> deleteById(String id) async {
    if (shouldThrow) throw Exception('mock dao error');
    rows.removeWhere((row) => row.id == id);
  }

  @override
  Future<void> replaceAll(List<CachedAssetsTableCompanion> entries) async {
    if (shouldThrow) throw Exception('mock dao error');
    rows
      ..clear()
      ..addAll(entries.map(_resolve));
  }

  CachedAssetsTableData _resolve(CachedAssetsTableCompanion entry) {
    final fallbackDate = DateTime(2026, 1, 1);
    return CachedAssetsTableData(
      id: entry.id.present ? entry.id.value : '',
      userId: entry.userId.present ? entry.userId.value : '',
      assetTypeCode: entry.assetTypeCode.present
          ? entry.assetTypeCode.value
          : '',
      assetTypeId: entry.assetTypeId.present ? entry.assetTypeId.value : '',
      amount: entry.amount.present ? entry.amount.value : '',
      priceAtEntry: entry.priceAtEntry.present ? entry.priceAtEntry.value : '',
      currentUnitPrice: entry.currentUnitPrice.present
          ? entry.currentUnitPrice.value
          : '',
      entryDate: entry.entryDate.present ? entry.entryDate.value : fallbackDate,
      note: entry.note.present ? entry.note.value : null,
      pendingSync: entry.pendingSync.present ? entry.pendingSync.value : false,
      lastSyncedAt: entry.lastSyncedAt.present
          ? entry.lastSyncedAt.value
          : null,
      createdAt: entry.createdAt.present ? entry.createdAt.value : fallbackDate,
      updatedAt: entry.updatedAt.present ? entry.updatedAt.value : fallbackDate,
    );
  }
}

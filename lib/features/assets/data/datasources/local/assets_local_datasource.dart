import 'package:drift/drift.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/local/cache/daos/asset_history_dao.dart';
import 'package:qeema/core/local/cache/daos/asset_types_dao.dart';
import 'package:qeema/core/local/cache/daos/assets_dao.dart';
import 'package:qeema/core/local/cache/daos/market_prices_dao.dart';
import 'package:qeema/features/assets/data/models/asset_model.dart';
import 'package:qeema/features/assets/data/models/asset_type_model.dart';

class AssetsLocalDataSource {
  const AssetsLocalDataSource(
    this._assetsDao,
    this._marketPricesDao,
    this._assetTypesDao,
    this._assetHistoryDao,
  );
  final AssetsDao _assetsDao;
  final MarketPricesDao _marketPricesDao;
  final AssetTypesDao _assetTypesDao;
  final AssetHistoryDao _assetHistoryDao;

  Stream<List<CachedAssetsTableData>> watchAssets(String userId) =>
      _assetsDao.watchActiveAssets(userId);

  Future<CachedMarketPricesTableData?> latestPrice(String assetTypeCode) =>
      _marketPricesDao.latestForType(assetTypeCode);

  Future<void> insertOrUpdateAsset(CachedAssetsTableCompanion entry) =>
      _assetsDao.insertOrUpdate(entry);

  Future<void> markPendingSync(String id) => _assetsDao.markPendingSync(id);

  Future<void> deleteAsset(String id) => _assetsDao.deleteById(id);

  Future<List<CachedMarketPricesTableData>> getAllPrices() =>
      _marketPricesDao.getAll();

  Future<void> insertOrUpdatePrice(CachedMarketPricesTableCompanion entry) =>
      _marketPricesDao.insertOrUpdate(entry);

  Future<List<CachedAssetTypesTableData>> getCachedAssetTypes() async {
    return _assetTypesDao.getAll();
  }

  Future<void> cacheAssetTypes(List<AssetTypeModel> types) async {
    for (final type in types) {
      await _assetTypesDao.insertOrUpdate(
        CachedAssetTypesTableCompanion.insert(
          id: type.id,
          code: type.code,
          name: type.name,
          isMarketBased: type.isMarketBased,
          displayIcon: Value<String?>(type.displayIcon),
        ),
      );
    }
  }

  Future<List<CachedAssetHistoryTableData>> getCachedHistory(
    String assetId,
  ) async {
    return _assetHistoryDao.getForAsset(assetId);
  }

  Future<void> cacheHistory(String assetId, List<AssetModel> history) async {
    await _assetHistoryDao.clearForAsset(assetId);
    for (final entry in history) {
      await _assetHistoryDao.insertOrUpdate(
        CachedAssetHistoryTableCompanion.insert(
          id: entry.id,
          assetId: assetId,
          fieldName: 'updated',
          oldValue: const Value<String?>(null),
          newValue: Value<String?>(entry.amount.toString()),
          changedAt: entry.updatedAt,
        ),
      );
    }
  }
}

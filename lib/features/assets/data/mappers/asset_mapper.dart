import 'package:decimal/decimal.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/features/assets/data/models/asset_model.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';

class AssetMapper {
  AssetEntity fromModel(AssetModel model) => model.toEntity();
  AssetModel toModel(AssetEntity entity) => AssetModel(
    id: entity.id,
    assetTypeId: entity.assetTypeId,
    assetTypeCode: entity.assetTypeCode,
    amount: entity.amount,
    priceAtEntry: entity.priceAtEntry,
    entryDate: entity.entryDate,
    note: entity.note,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );

  AssetEntity fromCached(CachedAssetsTableData cached) {
    return AssetEntity(
      id: cached.id,
      assetTypeId: cached.assetTypeId,
      assetTypeCode: cached.assetTypeCode,
      amount: Decimal.parse(cached.amount),
      priceAtEntry: Decimal.parse(cached.priceAtEntry),
      entryDate: cached.entryDate,
      note: cached.note,
      createdAt: cached.createdAt,
      updatedAt: cached.updatedAt,
    );
  }

  AssetTypeEntity assetTypeFromCached(CachedAssetTypesTableData cached) {
    return AssetTypeEntity(
      id: cached.id,
      code: cached.code,
      name: cached.name,
      isMarketBased: cached.isMarketBased,
      displayIcon: cached.displayIcon,
    );
  }

  AssetHistoryEntryEntity historyFromCached(
    CachedAssetHistoryTableData cached,
  ) {
    return AssetHistoryEntryEntity(
      id: cached.id,
      assetId: cached.assetId,
      changeType: cached.fieldName,
      changedAt: cached.changedAt,
    );
  }
}

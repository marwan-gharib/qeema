import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';

abstract class AssetsRepository {
  Stream<ApiResult<List<AssetEntity>>> watchAssets();
  Future<ApiResult<List<AssetTypeEntity>>> getAssetTypes();
  Future<ApiResult<AssetEntity>> addAsset(AddAssetParams params);
  Future<ApiResult<AssetEntity>> updateAsset(UpdateAssetParams params);
  Future<ApiResult<void>> softDeleteAsset(String assetId);
  Future<ApiResult<List<AssetHistoryEntryEntity>>> getAssetHistory(
    String assetId,
  );
}

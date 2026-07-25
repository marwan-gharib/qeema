import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';

abstract class AssetsRepository {
  Future<ApiResult<List<AssetEntity>>> getAssets();
  Future<ApiResult<List<AssetTypeEntity>>> getAssetTypes();
  Future<ApiResult<AssetEntity>> addAsset(AddAssetParams params);
}

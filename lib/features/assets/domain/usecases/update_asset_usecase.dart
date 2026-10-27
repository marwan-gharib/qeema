import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';

class UpdateAssetUseCase {
  const UpdateAssetUseCase(this._repository);
  final AssetsRepository _repository;

  Future<ApiResult<AssetEntity>> call(UpdateAssetParams params) =>
      _repository.updateAsset(params);
}

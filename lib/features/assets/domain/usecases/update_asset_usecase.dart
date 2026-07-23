import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';

class UpdateAssetUseCase implements UseCase<AssetEntity, UpdateAssetParams> {
  const UpdateAssetUseCase(this._repository);
  final AssetsRepository _repository;

  @override
  Future<ApiResult<AssetEntity>> call(UpdateAssetParams params) =>
      _repository.updateAsset(params);
}

import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';

class AddAssetUseCase implements UseCase<AssetEntity, AddAssetParams> {
  const AddAssetUseCase(this._repository);
  final AssetsRepository _repository;

  @override
  Future<ApiResult<AssetEntity>> call(AddAssetParams params) =>
      _repository.addAsset(params);
}

import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';

class GetAssetTypesUseCase {
  const GetAssetTypesUseCase(this._repository);
  final AssetsRepository _repository;

  Future<ApiResult<List<AssetTypeEntity>>> call() =>
      _repository.getAssetTypes();
}

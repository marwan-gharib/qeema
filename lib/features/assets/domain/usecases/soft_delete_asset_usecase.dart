import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';

class SoftDeleteAssetUseCase {
  const SoftDeleteAssetUseCase(this._repository);
  final AssetsRepository _repository;

  Future<ApiResult<void>> call(String assetId) =>
      _repository.softDeleteAsset(assetId);
}

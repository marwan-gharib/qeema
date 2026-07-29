import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';

class SoftDeleteAssetUseCase implements UseCase<void, String> {
  const SoftDeleteAssetUseCase(this._repository);
  final AssetsRepository _repository;

  @override
  Future<ApiResult<void>> call(String assetId) =>
      _repository.softDeleteAsset(assetId);
}

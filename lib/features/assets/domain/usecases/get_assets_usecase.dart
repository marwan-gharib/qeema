import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';

class GetAssetsUseCase
    implements StreamUseCaseWithoutParams<List<AssetEntity>> {
  const GetAssetsUseCase(this._repository);
  final AssetsRepository _repository;

  @override
  Stream<ApiResult<List<AssetEntity>>> call() => _repository.watchAssets();
}

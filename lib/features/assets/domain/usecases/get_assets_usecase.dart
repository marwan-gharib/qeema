import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';

class GetAssetsUseCase {
  const GetAssetsUseCase(this.repository);

  final AssetsRepository repository;

  Future<ApiResult<List<AssetEntity>>> call() => repository.getAssets();
}

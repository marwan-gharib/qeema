import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

abstract class AssetsRepository {
  Future<ApiResult<List<AssetEntity>>> getAssets();
}

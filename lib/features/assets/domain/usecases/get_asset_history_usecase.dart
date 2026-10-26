import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';

class GetAssetHistoryUseCase {
  const GetAssetHistoryUseCase(this._repository);
  final AssetsRepository _repository;

  Future<ApiResult<List<AssetHistoryEntryEntity>>> call(String assetId) =>
      _repository.getAssetHistory(assetId);
}

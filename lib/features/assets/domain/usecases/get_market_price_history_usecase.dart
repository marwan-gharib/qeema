import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';

class GetMarketPriceHistoryUseCase {
  const GetMarketPriceHistoryUseCase(this._repository);
  final AssetsRepository _repository;

  Future<ApiResult<List<MarketPriceEntity>>> call(String assetTypeCode) =>
      _repository.getPriceHistory(assetTypeCode);
}

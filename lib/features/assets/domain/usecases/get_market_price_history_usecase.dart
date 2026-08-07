import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';

class GetMarketPriceHistoryUseCase
    implements UseCase<List<MarketPriceEntity>, String> {
  const GetMarketPriceHistoryUseCase(this._repository);
  final AssetsRepository _repository;

  @override
  Future<ApiResult<List<MarketPriceEntity>>> call(String assetTypeCode) =>
      _repository.getPriceHistory(assetTypeCode);
}

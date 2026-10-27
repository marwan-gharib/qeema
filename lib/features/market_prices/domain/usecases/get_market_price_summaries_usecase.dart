import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';
import 'package:qeema/features/market_prices/domain/repositories/market_prices_repository.dart';

class GetMarketPriceSummariesUseCase {
  const GetMarketPriceSummariesUseCase(this._repository);
  final MarketPricesRepository _repository;

  Future<ApiResult<List<MarketPriceSummaryEntity>>> call({
    bool forceRefresh = false,
  }) => _repository.getSummaries(forceRefresh: forceRefresh);
}

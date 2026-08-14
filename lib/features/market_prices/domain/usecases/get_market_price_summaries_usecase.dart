import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase_without_params.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';
import 'package:qeema/features/market_prices/domain/repositories/market_prices_repository.dart';

class GetMarketPriceSummariesUseCase
    implements UseCaseWithoutParams<List<MarketPriceSummaryEntity>> {
  const GetMarketPriceSummariesUseCase(this._repository);
  final MarketPricesRepository _repository;

  @override
  Future<ApiResult<List<MarketPriceSummaryEntity>>> call() =>
      _repository.getSummaries();
}

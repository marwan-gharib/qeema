import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';
import 'package:qeema/features/market_prices/domain/params/get_market_price_range_params.dart';
import 'package:qeema/features/market_prices/domain/repositories/market_prices_repository.dart';

class GetMarketPriceRangeUseCase
    implements
        UseCase<List<MarketPricePointEntity>, GetMarketPriceRangeParams> {
  const GetMarketPriceRangeUseCase(this._repository);
  final MarketPricesRepository _repository;

  @override
  Future<ApiResult<List<MarketPricePointEntity>>> call(
    GetMarketPriceRangeParams params,
  ) => _repository.getRange(
    assetTypeCode: params.assetTypeCode,
    from: params.from,
    to: params.to,
  );
}

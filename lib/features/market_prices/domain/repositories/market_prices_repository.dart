import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';

abstract class MarketPricesRepository {
  Future<ApiResult<List<MarketPriceSummaryEntity>>> getSummaries();
  Future<ApiResult<List<MarketPricePointEntity>>> getRange({
    required String assetTypeCode,
    required DateTime from,
    required DateTime to,
  });
}

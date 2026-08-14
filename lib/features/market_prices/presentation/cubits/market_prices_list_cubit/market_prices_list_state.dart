import 'package:qeema/core/error/failures.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';

sealed class MarketPricesListState {
  const MarketPricesListState();
}

final class MarketPricesListLoading extends MarketPricesListState {
  const MarketPricesListLoading();
}

final class MarketPricesListLoaded extends MarketPricesListState {
  const MarketPricesListLoaded(this.summaries);
  final List<MarketPriceSummaryEntity> summaries;
}

final class MarketPricesListError extends MarketPricesListState {
  const MarketPricesListError(this.failure);
  final Failure failure;
}

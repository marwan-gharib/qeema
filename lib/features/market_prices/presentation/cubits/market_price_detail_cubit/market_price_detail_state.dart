import 'package:qeema/core/error/failures.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';

enum MarketPriceRangeOption { oneWeek, oneMonth, threeMonths }

sealed class MarketPriceDetailState {
  const MarketPriceDetailState();
}

final class MarketPriceDetailLoading extends MarketPriceDetailState {
  const MarketPriceDetailLoading();
}

final class MarketPriceDetailLoaded extends MarketPriceDetailState {
  const MarketPriceDetailLoaded({
    required this.assetType,
    required this.points,
    required this.selectedRange,
    required this.daysCovered,
  });

  final AssetTypeEntity assetType;
  final List<MarketPricePointEntity> points;
  final MarketPriceRangeOption selectedRange;
  final int daysCovered;
}

final class MarketPriceDetailError extends MarketPriceDetailState {
  const MarketPriceDetailError(this.failure);
  final Failure failure;
}

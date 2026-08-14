import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';

class MarketPricePointMapper {
  const MarketPricePointMapper._();

  static MarketPricePointEntity fromMarketPrice(MarketPriceEntity entity) {
    return MarketPricePointEntity(date: entity.priceDate, price: entity.price);
  }

  static MarketPriceEntity toMarketPrice(MarketPricePointEntity point) {
    return MarketPriceEntity(priceDate: point.date, price: point.price);
  }
}

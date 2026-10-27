import 'package:decimal/decimal.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';

class MarketPricePointEntity {
  const MarketPricePointEntity({required this.date, required this.price});

  /// Adapts one row of the assets feature's price history into a chart point.
  factory MarketPricePointEntity.fromMarketPrice(MarketPriceEntity entity) {
    return MarketPricePointEntity(date: entity.priceDate, price: entity.price);
  }

  final DateTime date;
  final Decimal price;

  /// Rebuilds the assets feature's price row for chart rendering.
  MarketPriceEntity toMarketPrice() =>
      MarketPriceEntity(priceDate: date, price: price);
}

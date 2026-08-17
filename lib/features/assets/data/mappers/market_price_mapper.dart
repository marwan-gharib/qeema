import 'package:decimal/decimal.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';

class MarketPriceMapper {
  const MarketPriceMapper._();

  static MarketPriceEntity fromRow(Map<String, dynamic> row) {
    final fetchedAtRaw = row['fetched_at'];
    return MarketPriceEntity(
      priceDate: DateTime.parse(row['price_date'] as String),
      price: Decimal.parse((row['price'] as num).toString()),
      fetchedAt: fetchedAtRaw is String ? DateTime.parse(fetchedAtRaw) : null,
    );
  }
}

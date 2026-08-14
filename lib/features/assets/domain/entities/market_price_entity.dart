import 'package:decimal/decimal.dart';

class MarketPriceEntity {
  const MarketPriceEntity({
    required this.priceDate,
    required this.price,
    this.fetchedAt,
  });

  final DateTime priceDate;
  final Decimal price;

  /// When the row was fetched from the source by the price cron — used by the
  /// market prices feature to surface stale data.
  final DateTime? fetchedAt;
}

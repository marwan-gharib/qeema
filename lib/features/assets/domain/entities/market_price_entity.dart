import 'package:decimal/decimal.dart';

class MarketPriceEntity {
  const MarketPriceEntity({required this.priceDate, required this.price});

  final DateTime priceDate;
  final Decimal price;
}

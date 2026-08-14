import 'package:decimal/decimal.dart';

class MarketPricePointEntity {
  const MarketPricePointEntity({required this.date, required this.price});

  final DateTime date;
  final Decimal price;
}

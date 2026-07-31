import 'package:decimal/decimal.dart';

class MarketPriceRow {
  const MarketPriceRow({
    required this.assetTypeCode,
    required this.priceDate,
    required this.price,
  });

  factory MarketPriceRow.fromJson(Map<String, dynamic> json) {
    final typeData = json['asset_types'] as Map<String, dynamic>?;
    return MarketPriceRow(
      assetTypeCode: typeData?['code'] as String? ?? '',
      priceDate: DateTime.parse(json['price_date'] as String),
      price: Decimal.parse((json['price'] as num).toString()),
    );
  }

  final String assetTypeCode;
  final DateTime priceDate;
  final Decimal price;
}

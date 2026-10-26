import 'package:decimal/decimal.dart';
import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';

/// One market_prices server row, parsed at the data-layer boundary.
class MarketPriceModel {
  const MarketPriceModel({
    required this.priceDate,
    required this.price,
    this.fetchedAt,
  });

  factory MarketPriceModel.fromRow(Map<String, dynamic> row) {
    final fetchedAtRaw = row[SupabaseColumns.fetchedAt];
    return MarketPriceModel(
      priceDate: DateTime.parse(row[SupabaseColumns.priceDate] as String),
      price: Decimal.parse((row[SupabaseColumns.price] as num).toString()),
      fetchedAt: fetchedAtRaw is String ? DateTime.parse(fetchedAtRaw) : null,
    );
  }

  final DateTime priceDate;
  final Decimal price;
  final DateTime? fetchedAt;

  MarketPriceEntity toEntity() => MarketPriceEntity(
    priceDate: priceDate,
    price: price,
    fetchedAt: fetchedAt,
  );
}

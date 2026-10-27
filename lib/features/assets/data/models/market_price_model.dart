import 'package:decimal/decimal.dart';
import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/features/assets/data/models/row_parsing.dart';
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
      priceDate: requiredDate(row, SupabaseColumns.priceDate),
      price: Decimal.parse(requiredNum(row, SupabaseColumns.price).toString()),
      fetchedAt: fetchedAtRaw is String
          ? (DateTime.tryParse(fetchedAtRaw) ??
                malformed(SupabaseColumns.fetchedAt, fetchedAtRaw))
          : null,
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

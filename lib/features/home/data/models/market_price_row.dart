import 'package:decimal/decimal.dart';
import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/core/constants/supabase_tables.dart';

class MarketPriceRow {
  const MarketPriceRow({
    required this.assetTypeCode,
    required this.priceDate,
    required this.price,
  });

  factory MarketPriceRow.fromJson(Map<String, dynamic> json) {
    final typeData = json[SupabaseTables.assetTypes] as Map<String, dynamic>?;
    return MarketPriceRow(
      assetTypeCode: typeData?[SupabaseColumns.code] as String? ?? '',
      priceDate: DateTime.parse(json[SupabaseColumns.priceDate] as String),
      price: Decimal.parse((json[SupabaseColumns.price] as num).toString()),
    );
  }

  final String assetTypeCode;
  final DateTime priceDate;
  final Decimal price;
}

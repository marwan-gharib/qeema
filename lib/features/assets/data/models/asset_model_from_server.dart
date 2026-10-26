import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/core/constants/supabase_tables.dart';
import 'package:qeema/core/utils/asset_type_parsing.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

/// One asset as returned by the joined assets/market_prices server query.
class AssetModelFromServer {
  AssetModelFromServer({
    required this.id,
    required this.assetTypeCode,
    required this.amount,
    required this.priceAtEntry,
    required this.entryDate,
    this.note,
    this.currentPrice,
  });

  factory AssetModelFromServer.fromJson(
    Map<String, dynamic> json, {
    double? currentPrice,
  }) {
    final typeData = json[SupabaseTables.assetTypes] as Map<String, dynamic>?;
    final typeCode = typeData?[SupabaseColumns.code] as String? ?? '';
    return AssetModelFromServer(
      id: json[SupabaseColumns.id] as String,
      assetTypeCode: typeCode,
      amount: (json[SupabaseColumns.amount] as num).toDouble(),
      priceAtEntry: (json[SupabaseColumns.priceAtEntry] as num).toDouble(),
      entryDate: DateTime.parse(json[SupabaseColumns.entryDate] as String),
      note: json[SupabaseColumns.note] as String?,
      currentPrice: currentPrice,
    );
  }

  final String id;
  final String assetTypeCode;
  final double amount;
  final double priceAtEntry;
  final DateTime entryDate;
  final String? note;
  final double? currentPrice;

  AssetEntity toEntity() => AssetEntity(
    id: id,
    assetType: assetTypeFromString(assetTypeCode),
    amount: amount,
    priceAtEntry: priceAtEntry,
    entryDate: entryDate,
    note: note,
    currentPrice: currentPrice,
  );
}

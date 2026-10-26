import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/core/constants/supabase_tables.dart';
import 'package:qeema/core/utils/asset_type_parsing.dart';
import 'package:qeema/features/assets/data/models/row_parsing.dart';
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
    final typeData = optionalMap(json, SupabaseTables.assetTypes);
    final codeValue = typeData?[SupabaseColumns.code];
    final typeCode = codeValue == null
        ? ''
        : codeValue is String
        ? codeValue
        : malformed(SupabaseColumns.code, codeValue);
    return AssetModelFromServer(
      id: requiredString(json, SupabaseColumns.id),
      assetTypeCode: typeCode,
      amount: requiredNum(json, SupabaseColumns.amount).toDouble(),
      priceAtEntry: requiredNum(json, SupabaseColumns.priceAtEntry).toDouble(),
      entryDate: requiredDate(json, SupabaseColumns.entryDate),
      note: optionalString(json, SupabaseColumns.note),
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

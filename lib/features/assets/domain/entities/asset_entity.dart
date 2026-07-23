import 'package:decimal/decimal.dart';

class AssetEntity {
  const AssetEntity({
    required this.id,
    required this.assetTypeId,
    required this.assetTypeCode,
    required this.amount,
    required this.priceAtEntry,
    required this.entryDate,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String assetTypeId;
  final String assetTypeCode;
  final Decimal amount;
  final Decimal priceAtEntry;
  final DateTime entryDate;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
}

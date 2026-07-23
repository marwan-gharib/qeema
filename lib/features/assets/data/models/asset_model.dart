import 'package:decimal/decimal.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

class AssetModel {
  const AssetModel({
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

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
      id: json['id'] as String,
      assetTypeId: json['asset_type_id'] as String,
      assetTypeCode: json['asset_type_code'] as String,
      amount: Decimal.parse(json['amount'].toString()),
      priceAtEntry: Decimal.parse(json['price_at_entry'].toString()),
      entryDate: DateTime.parse(json['entry_date'] as String),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  final String id;
  final String assetTypeId;
  final String assetTypeCode;
  final Decimal amount;
  final Decimal priceAtEntry;
  final DateTime entryDate;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssetEntity toEntity() => AssetEntity(
    id: id,
    assetTypeId: assetTypeId,
    assetTypeCode: assetTypeCode,
    amount: amount,
    priceAtEntry: priceAtEntry,
    entryDate: entryDate,
    note: note,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

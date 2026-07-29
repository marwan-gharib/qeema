import 'package:qeema/core/utils/asset_type_parsing.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

class AssetModel extends AssetEntity {
  const AssetModel({
    required super.id,
    required super.assetType,
    required super.amount,
    required super.priceAtEntry,
    required super.entryDate,
    super.note,
    super.currentPrice,
  });

  factory AssetModel.fromJson(
    Map<String, dynamic> json, {
    double? currentPrice,
  }) {
    final assetTypeData = json['asset_types'] as Map<String, dynamic>?;
    final typeCode = assetTypeData?['code'] as String? ?? '';
    return AssetModel(
      id: json['id'] as String,
      assetType: assetTypeFromString(typeCode),
      amount: (json['amount'] as num).toDouble(),
      priceAtEntry: (json['price_at_entry'] as num).toDouble(),
      entryDate: DateTime.parse(json['entry_date'] as String),
      note: json['note'] as String?,
      currentPrice: currentPrice,
    );
  }
}

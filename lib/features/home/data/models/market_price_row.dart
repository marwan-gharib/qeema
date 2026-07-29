import 'package:qeema/core/utils/asset_type_parsing.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

class MarketPriceRow {
  const MarketPriceRow({
    required this.assetType,
    required this.price,
    required this.previousPrice,
  });

  factory MarketPriceRow.fromJson(Map<String, dynamic> json) {
    final typeData = json['asset_types'] as Map<String, dynamic>?;
    final code = typeData?['code'] as String? ?? '';
    return MarketPriceRow(
      assetType: assetTypeFromString(code),
      price: (json['price'] as num).toDouble(),
      previousPrice:
          (json['previous_price'] as num?)?.toDouble() ??
          (json['price'] as num).toDouble(),
    );
  }

  final AssetType assetType;
  final double price;
  final double previousPrice;
}

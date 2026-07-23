import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';

class AssetTypeModel {
  const AssetTypeModel({
    required this.id,
    required this.code,
    required this.name,
    required this.isMarketBased,
    this.displayIcon,
  });

  factory AssetTypeModel.fromJson(Map<String, dynamic> json) {
    return AssetTypeModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      isMarketBased: json['is_market_based'] as bool,
      displayIcon: json['display_icon'] as String?,
    );
  }

  final String id;
  final String code;
  final String name;
  final bool isMarketBased;
  final String? displayIcon;

  AssetTypeEntity toEntity() => AssetTypeEntity(
    id: id,
    code: code,
    name: name,
    isMarketBased: isMarketBased,
    displayIcon: displayIcon,
  );
}

class AssetTypeEntity {
  const AssetTypeEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.isMarketBased,
    required this.baseUnit,
  });

  final String id;
  final String code;
  final String name;
  final bool isMarketBased;
  final String baseUnit;
}

class AssetTypeEntity {
  const AssetTypeEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.isMarketBased,
    this.displayIcon,
  });

  final String id;
  final String code;
  final String name;
  final bool isMarketBased;
  final String? displayIcon;
}

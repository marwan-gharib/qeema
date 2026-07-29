import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

AssetType assetTypeFromString(String code) {
  switch (code) {
    case 'cash_egp':
      return AssetType.egpCash;
    case 'usd':
      return AssetType.usdCash;
    case 'gold_21':
      return AssetType.gold21;
    case 'gold_24':
      return AssetType.gold24;
    default:
      throw FormatException('Unknown asset type code: $code');
  }
}

String assetTypeToString(AssetType type) {
  switch (type) {
    case AssetType.egpCash:
      return 'cash_egp';
    case AssetType.usdCash:
      return 'usd';
    case AssetType.gold21:
      return 'gold_21';
    case AssetType.gold24:
      return 'gold_24';
  }
}

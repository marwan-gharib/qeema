import 'package:qeema/core/constants/asset_type_codes.dart';
import 'package:qeema/core/domain/asset_type.dart';

AssetType assetTypeFromString(String code) {
  switch (code) {
    case AssetTypeCodes.cashEgp:
      return AssetType.egpCash;
    case AssetTypeCodes.usd:
      return AssetType.usdCash;
    case AssetTypeCodes.gold21:
      return AssetType.gold21;
    case AssetTypeCodes.gold24:
      return AssetType.gold24;
    default:
      throw FormatException('Unknown asset type code: $code');
  }
}

String assetTypeToString(AssetType type) {
  switch (type) {
    case AssetType.egpCash:
      return AssetTypeCodes.cashEgp;
    case AssetType.usdCash:
      return AssetTypeCodes.usd;
    case AssetType.gold21:
      return AssetTypeCodes.gold21;
    case AssetType.gold24:
      return AssetTypeCodes.gold24;
  }
}

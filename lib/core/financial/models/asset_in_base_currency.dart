import 'package:decimal/decimal.dart';

class AssetInBaseCurrency {
  const AssetInBaseCurrency._(this.sourceAssetId, this.valueInBaseCurrency);
  final String sourceAssetId;
  final Decimal valueInBaseCurrency;

  static AssetInBaseCurrency internalConstruct(
    String sourceAssetId,
    Decimal value,
  ) => AssetInBaseCurrency._(sourceAssetId, value);
}

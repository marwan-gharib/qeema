import 'package:decimal/decimal.dart';

class AssetInBaseCurrency {
  final String sourceAssetId;
  final Decimal valueInBaseCurrency;

  const AssetInBaseCurrency._(this.sourceAssetId, this.valueInBaseCurrency);

  static AssetInBaseCurrency internalConstruct(
    String sourceAssetId,
    Decimal value,
  ) => AssetInBaseCurrency._(sourceAssetId, value);
}

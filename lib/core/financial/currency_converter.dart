import 'package:decimal/decimal.dart';

import '../constants/asset_type_codes.dart';
import '../error/failures.dart';
import '../utils/api_result.dart';
import 'models/asset_in_base_currency.dart';

class CurrencyConverter {
  static const _baseCurrencyAssetCode = AssetTypeCodes.cashEgp;

  Decimal _d(dynamic v) => Decimal.parse(v.toString());

  ApiResult<AssetInBaseCurrency> toBaseCurrency({
    required String sourceAssetId,
    required Decimal amount,
    required String assetTypeCode,
    required bool isMarketBased,
    required Decimal? latestPrice,
  }) {
    if (assetTypeCode == _baseCurrencyAssetCode) {
      return Success(
        AssetInBaseCurrency.internalConstruct(sourceAssetId, amount),
      );
    }
    if (!isMarketBased) {
      return ResultFailure(
        CalculationFailure(
          'Asset type $assetTypeCode is not market-based but is not base currency',
        ),
      );
    }
    if (latestPrice == null) {
      return ResultFailure(PriceFetchFailure(assetTypeCode));
    }
    return Success(
      AssetInBaseCurrency.internalConstruct(
        sourceAssetId,
        _d(amount * latestPrice),
      ),
    );
  }
}

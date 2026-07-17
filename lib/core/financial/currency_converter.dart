import 'package:decimal/decimal.dart';
import 'package:qeema/core/constants/asset_type_codes.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/financial/models/asset_in_base_currency.dart';
import 'package:qeema/core/utils/api_result.dart';

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
      return ResultFailure(CalculationFailure(assetTypeCode));
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

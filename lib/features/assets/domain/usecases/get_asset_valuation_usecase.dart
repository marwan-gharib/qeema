import 'package:decimal/decimal.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/financial/asset_valuator.dart';
import 'package:qeema/core/local/cache/daos/market_prices_dao.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

class AssetValuationResult {
  const AssetValuationResult({
    required this.currentValue,
    required this.unrealizedGainLoss,
    required this.gainLossPercentage,
    required this.priceAtEntry,
    required this.currentUnitPrice,
  });

  final Decimal currentValue;
  final Decimal unrealizedGainLoss;
  final Decimal gainLossPercentage;
  final Decimal priceAtEntry;
  final Decimal currentUnitPrice;
}

class GetAssetValuationUseCase
    implements UseCase<AssetValuationResult, AssetEntity> {
  const GetAssetValuationUseCase(this._assetValuator, this._marketPricesDao);

  final AssetValuator _assetValuator;
  final MarketPricesDao _marketPricesDao;

  @override
  Future<ApiResult<AssetValuationResult>> call(AssetEntity asset) async {
    if (asset.assetTypeCode == 'cash_egp') {
      return Success(
        AssetValuationResult(
          currentValue: asset.amount,
          unrealizedGainLoss: Decimal.zero,
          gainLossPercentage: Decimal.zero,
          priceAtEntry: Decimal.one,
          currentUnitPrice: Decimal.one,
        ),
      );
    }

    final priceRow = await _marketPricesDao.latestForType(asset.assetTypeCode);
    if (priceRow == null) {
      return ResultFailure(PriceFetchFailure(asset.assetTypeCode));
    }

    final currentUnitPrice = Decimal.tryParse(priceRow.price) ?? Decimal.zero;
    if (currentUnitPrice == Decimal.zero) {
      return ResultFailure(PriceFetchFailure(asset.assetTypeCode));
    }

    return Success(
      AssetValuationResult(
        currentValue: _assetValuator.currentValue(
          amount: asset.amount,
          currentUnitPrice: currentUnitPrice,
        ),
        unrealizedGainLoss: _assetValuator.unrealizedGainLoss(
          amount: asset.amount,
          priceAtEntry: asset.priceAtEntry,
          currentUnitPrice: currentUnitPrice,
        ),
        gainLossPercentage: _assetValuator.gainLossPercentage(
          amount: asset.amount,
          priceAtEntry: asset.priceAtEntry,
          currentUnitPrice: currentUnitPrice,
        ),
        priceAtEntry: asset.priceAtEntry,
        currentUnitPrice: currentUnitPrice,
      ),
    );
  }
}

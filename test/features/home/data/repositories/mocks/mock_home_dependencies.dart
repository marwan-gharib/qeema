import 'package:decimal/decimal.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/financial/currency_converter.dart';
import 'package:qeema/core/financial/inflation_calculator.dart';
import 'package:qeema/core/financial/models/asset_in_base_currency.dart';
import 'package:qeema/core/financial/models/monthly_inflation_rate.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:qeema/features/home/data/datasources/home_remote_datasource.dart';
import 'package:qeema/features/home/data/models/inflation_rate_row.dart';
import 'package:qeema/features/home/data/models/market_price_row.dart';
import 'package:qeema/features/home/data/models/portfolio_snapshot_row.dart';

class MockAssetsRepository implements AssetsRepository {
  MockAssetsRepository({
    this.assetsResult = const Success([]),
    this.assetTypesResult = const Success([]),
  });

  ApiResult<List<AssetEntity>> assetsResult;
  ApiResult<List<AssetTypeEntity>> assetTypesResult;

  @override
  Future<ApiResult<List<AssetEntity>>> getAssets() async => assetsResult;

  @override
  Future<ApiResult<List<AssetEntity>>> refreshAssets() async => assetsResult;

  @override
  Future<ApiResult<List<AssetTypeEntity>>> getAssetTypes() async =>
      assetTypesResult;

  @override
  Future<ApiResult<AssetEntity>> addAsset(AddAssetParams params) =>
      throw UnimplementedError();

  @override
  Future<ApiResult<AssetEntity>> updateAsset(UpdateAssetParams params) =>
      throw UnimplementedError();

  @override
  Future<ApiResult<void>> softDeleteAsset(String assetId) =>
      throw UnimplementedError();

  @override
  Future<ApiResult<List<AssetHistoryEntryEntity>>> getAssetHistory(
    String assetId,
  ) => throw UnimplementedError();

  @override
  Future<ApiResult<List<MarketPriceEntity>>> getPriceHistory(
    String assetTypeCode,
  ) => throw UnimplementedError();
}

class MockHomeRemoteDataSource implements HomeRemoteDataSource {
  ApiResult<List<MarketPriceRow>> marketPricesResult = const Success([]);
  ApiResult<List<InflationRateRow>> inflationRatesResult = const Success([]);
  ApiResult<List<PortfolioSnapshotRow>> portfolioSnapshotsResult =
      const Success([]);

  @override
  Future<ApiResult<List<MarketPriceRow>>> getMarketPrices() async =>
      marketPricesResult;

  @override
  Future<ApiResult<List<InflationRateRow>>> getInflationRates() async =>
      inflationRatesResult;

  @override
  Future<ApiResult<List<PortfolioSnapshotRow>>> getPortfolioSnapshots() async =>
      portfolioSnapshotsResult;
}

class MockCurrencyConverter implements CurrencyConverter {
  MockCurrencyConverter({this.pricesByCode = const {}});

  /// Price multiplier per asset type code; cash_egp always passes through.
  final Map<String, Decimal> pricesByCode;

  @override
  ApiResult<AssetInBaseCurrency> toBaseCurrency({
    required String sourceAssetId,
    required Decimal amount,
    required String assetTypeCode,
    required bool isMarketBased,
    required Decimal? latestPrice,
  }) {
    if (assetTypeCode == 'cash_egp') {
      return Success(
        AssetInBaseCurrency.internalConstruct(sourceAssetId, amount),
      );
    }
    final price = pricesByCode[assetTypeCode];
    if (!isMarketBased) {
      return ResultFailure(CalculationFailure(assetTypeCode));
    }
    if (price == null) {
      return ResultFailure(PriceFetchFailure(assetTypeCode));
    }
    return Success(
      AssetInBaseCurrency.internalConstruct(sourceAssetId, amount * price),
    );
  }
}

class MockInflationCalculator implements InflationCalculator {
  ApiResult<Decimal> result = Success(Decimal.fromInt(100));
  int callCount = 0;

  @override
  ApiResult<Decimal> calculateRealValue({
    required Decimal nominalValue,
    required List<MonthlyInflationRate> ratesInRange,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    callCount++;
    return result;
  }
}

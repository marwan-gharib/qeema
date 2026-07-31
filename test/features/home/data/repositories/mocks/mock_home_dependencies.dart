import 'package:decimal/decimal.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/financial/currency_converter.dart';
import 'package:qeema/core/financial/inflation_calculator.dart';
import 'package:qeema/core/financial/models/asset_in_base_currency.dart';
import 'package:qeema/core/financial/models/monthly_inflation_rate.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/home/data/datasources/home_remote_datasource.dart';
import 'package:qeema/features/home/data/models/inflation_rate_row.dart';
import 'package:qeema/features/home/data/models/market_price_row.dart';
import 'package:qeema/features/home/data/models/portfolio_snapshot_row.dart';

class MockGetAssetsUseCase implements GetAssetsUseCase {
  MockGetAssetsUseCase({this.result = const Success([])});

  ApiResult<List<AssetEntity>> result;

  @override
  AssetsRepository get repository => throw UnimplementedError();

  @override
  Future<ApiResult<List<AssetEntity>>> call() async => result;
}

class MockGetAssetTypesUseCase implements GetAssetTypesUseCase {
  MockGetAssetTypesUseCase({this.result = const Success([])});

  ApiResult<List<AssetTypeEntity>> result;

  @override
  Future<ApiResult<List<AssetTypeEntity>>> call() async => result;
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

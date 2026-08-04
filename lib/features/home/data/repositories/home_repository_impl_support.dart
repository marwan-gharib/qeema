import 'package:decimal/decimal.dart';
import 'package:qeema/core/extensions/decimal_extensions.dart';
import 'package:qeema/core/financial/currency_converter.dart';
import 'package:qeema/core/financial/inflation_calculator.dart';
import 'package:qeema/core/financial/models/monthly_inflation_rate.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/asset_type_parsing.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/home/data/datasources/home_remote_datasource.dart';
import 'package:qeema/features/home/data/mappers/portfolio_snapshot_mapper.dart';
import 'package:qeema/features/home/data/models/inflation_rate_row.dart';
import 'package:qeema/features/home/data/models/market_price_row.dart';
import 'package:qeema/features/home/data/models/portfolio_snapshot_row.dart';
import 'package:qeema/features/home/domain/entities/asset_type_summary_entity.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';

mixin HomeRepositoryImplSupport {
  GetAssetsUseCase get getAssetsUseCase;
  GetAssetTypesUseCase get getAssetTypesUseCase;
  HomeRemoteDataSource get remoteDataSource;
  CurrencyConverter get currencyConverter;
  InflationCalculator get inflationCalculator;

  Future<ApiResult<DashboardSummaryEntity>> loadAssetTypes(
    List<AssetEntity> assets,
  ) async {
    final typesResult = await getAssetTypesUseCase.call();
    return typesResult.fold(
      onSuccess: (List<AssetTypeEntity> types) => loadPrices(assets, types),
      onFailure: (failure) async => ResultFailure(failure),
    );
  }

  Future<ApiResult<DashboardSummaryEntity>> loadPrices(
    List<AssetEntity> assets,
    List<AssetTypeEntity> types,
  ) async {
    final pricesResult = await remoteDataSource.getMarketPrices();
    return pricesResult.fold(
      onSuccess: (prices) => loadInflation(assets, types, prices),
      onFailure: (failure) async => ResultFailure(failure),
    );
  }

  Future<ApiResult<DashboardSummaryEntity>> loadInflation(
    List<AssetEntity> assets,
    List<AssetTypeEntity> types,
    List<MarketPriceRow> prices,
  ) async {
    final inflationResult = await remoteDataSource.getInflationRates();
    return inflationResult.fold(
      onSuccess: (inflation) => loadSnapshots(assets, types, prices, inflation),
      onFailure: (failure) async => ResultFailure(failure),
    );
  }

  Future<ApiResult<DashboardSummaryEntity>> loadSnapshots(
    List<AssetEntity> assets,
    List<AssetTypeEntity> types,
    List<MarketPriceRow> prices,
    List<InflationRateRow> inflation,
  ) async {
    final snapshotsResult = await remoteDataSource.getPortfolioSnapshots();
    return snapshotsResult.fold(
      onSuccess: (snapshots) async =>
          Success(assemble(assets, types, prices, inflation, snapshots)),
      onFailure: (failure) async => ResultFailure(failure),
    );
  }

  DashboardSummaryEntity assemble(
    List<AssetEntity> assets,
    List<AssetTypeEntity> types,
    List<MarketPriceRow> priceRows,
    List<InflationRateRow> inflationRows,
    List<PortfolioSnapshotRow> snapshotRows,
  ) {
    final pricesByCode = twoRecentPricesByCode(priceRows);
    final typeByCode = {for (final t in types) t.code: t};

    var nominalTotal = Decimal.zero;
    var realTotal = Decimal.zero;
    final nominalByCode = <String, Decimal>{};

    for (final asset in assets) {
      final code = assetTypeToString(asset.assetType);
      final type = typeByCode[code];
      if (type == null) continue;

      final converted = currencyConverter.toBaseCurrency(
        sourceAssetId: asset.id,
        amount: Decimal.parse(asset.amount.toString()),
        assetTypeCode: code,
        isMarketBased: type.isMarketBased,
        latestPrice: pricesByCode[code]?.latest,
      );
      final nominal = converted.fold<Decimal?>(
        onSuccess: (result) => result.valueInBaseCurrency,
        onFailure: (_) => null,
      );
      if (nominal == null) continue;

      nominalTotal += nominal;
      nominalByCode[code] = (nominalByCode[code] ?? Decimal.zero) + nominal;

      final real = realValue(asset, nominal, inflationRows);
      if (real != null) {
        realTotal += real;
      }
    }

    final summaries = types.map((type) {
      final prices = pricesByCode[type.code];
      final latest = prices?.latest;
      final previous = prices?.previous;
      final hasSufficientPriceHistory =
          latest != null && previous != null && previous != Decimal.zero;
      final dayChange = hasSufficientPriceHistory
          ? (latest - previous).divideBy(previous) * Decimal.fromInt(100)
          : Decimal.zero;
      return AssetTypeSummaryEntity(
        assetType: type,
        currentValue: nominalByCode[type.code] ?? Decimal.zero,
        dayChangePercent: dayChange,
        hasSufficientPriceHistory: hasSufficientPriceHistory,
      );
    }).toList();

    final trend = snapshotRows.map(PortfolioSnapshotMapper.fromRow).toList();

    return DashboardSummaryEntity(
      nominalTotal: nominalTotal,
      realTotal: realTotal,
      assetTypeSummaries: summaries,
      trend30Days: trend,
    );
  }

  Decimal? realValue(
    AssetEntity asset,
    Decimal nominal,
    List<InflationRateRow> inflationRows,
  ) {
    final today = DateTime.now();
    final fromMonth = DateTime(asset.entryDate.year, asset.entryDate.month);
    final toMonth = DateTime(today.year, today.month);

    final ratesInRange = inflationRows
        .where((r) {
          final month = DateTime(r.month.year, r.month.month);
          return !month.isBefore(fromMonth) && !month.isAfter(toMonth);
        })
        .map(
          (r) => MonthlyInflationRate(
            month: DateTime(r.month.year, r.month.month),
            rate: r.rate,
          ),
        )
        .toList();

    final result = inflationCalculator.calculateRealValue(
      nominalValue: nominal,
      ratesInRange: ratesInRange,
      fromDate: asset.entryDate,
      toDate: today,
    );
    return result.fold<Decimal?>(
      onSuccess: (value) => value,
      onFailure: (_) => null,
    );
  }

  Map<String, TwoRecentPrices> twoRecentPricesByCode(
    List<MarketPriceRow> rows,
  ) {
    final result = <String, TwoRecentPrices>{};
    for (final row in rows) {
      final existing = result[row.assetTypeCode];
      if (existing == null) {
        result[row.assetTypeCode] = TwoRecentPrices(
          latest: row.price,
          previous: null,
        );
      } else if (existing.previous == null) {
        result[row.assetTypeCode] = TwoRecentPrices(
          latest: existing.latest,
          previous: row.price,
        );
      }
    }
    return result;
  }
}

class TwoRecentPrices {
  const TwoRecentPrices({required this.latest, required this.previous});

  final Decimal latest;
  final Decimal? previous;
}

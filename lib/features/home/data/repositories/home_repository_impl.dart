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
import 'package:qeema/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(
    this._getAssetsUseCase,
    this._getAssetTypesUseCase,
    this._remoteDataSource,
    this._currencyConverter,
    this._inflationCalculator,
  );

  final GetAssetsUseCase _getAssetsUseCase;
  final GetAssetTypesUseCase _getAssetTypesUseCase;
  final HomeRemoteDataSource _remoteDataSource;
  final CurrencyConverter _currencyConverter;
  final InflationCalculator _inflationCalculator;

  @override
  Future<ApiResult<DashboardSummaryEntity>> getDashboardSummary() async {
    final assetsResult = await _getAssetsUseCase.call();
    return assetsResult.fold(
      onSuccess: _loadAssetTypes,
      onFailure: (failure) async => ResultFailure(failure),
    );
  }

  Future<ApiResult<DashboardSummaryEntity>> _loadAssetTypes(
    List<AssetEntity> assets,
  ) async {
    final typesResult = await _getAssetTypesUseCase.call();
    return typesResult.fold(
      onSuccess: (types) => _loadPrices(assets, types),
      onFailure: (failure) async => ResultFailure(failure),
    );
  }

  Future<ApiResult<DashboardSummaryEntity>> _loadPrices(
    List<AssetEntity> assets,
    List<AssetTypeEntity> types,
  ) async {
    final pricesResult = await _remoteDataSource.getMarketPrices();
    return pricesResult.fold(
      onSuccess: (prices) => _loadInflation(assets, types, prices),
      onFailure: (failure) async => ResultFailure(failure),
    );
  }

  Future<ApiResult<DashboardSummaryEntity>> _loadInflation(
    List<AssetEntity> assets,
    List<AssetTypeEntity> types,
    List<MarketPriceRow> prices,
  ) async {
    final inflationResult = await _remoteDataSource.getInflationRates();
    return inflationResult.fold(
      onSuccess: (inflation) =>
          _loadSnapshots(assets, types, prices, inflation),
      onFailure: (failure) async => ResultFailure(failure),
    );
  }

  Future<ApiResult<DashboardSummaryEntity>> _loadSnapshots(
    List<AssetEntity> assets,
    List<AssetTypeEntity> types,
    List<MarketPriceRow> prices,
    List<InflationRateRow> inflation,
  ) async {
    final snapshotsResult = await _remoteDataSource.getPortfolioSnapshots();
    return snapshotsResult.fold(
      onSuccess: (snapshots) async =>
          Success(_assemble(assets, types, prices, inflation, snapshots)),
      onFailure: (failure) async => ResultFailure(failure),
    );
  }

  DashboardSummaryEntity _assemble(
    List<AssetEntity> assets,
    List<AssetTypeEntity> types,
    List<MarketPriceRow> priceRows,
    List<InflationRateRow> inflationRows,
    List<PortfolioSnapshotRow> snapshotRows,
  ) {
    final pricesByCode = _twoRecentPricesByCode(priceRows);
    final typeByCode = {for (final t in types) t.code: t};

    var nominalTotal = Decimal.zero;
    var realTotal = Decimal.zero;
    final nominalByCode = <String, Decimal>{};

    for (final asset in assets) {
      final code = assetTypeToString(asset.assetType);
      final type = typeByCode[code];
      if (type == null) continue;

      final converted = _currencyConverter.toBaseCurrency(
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

      final real = _realValue(asset, nominal, inflationRows);
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

  /// Assets whose inflation history is incomplete are excluded from the real
  /// total but still counted in the nominal total — a known limitation
  /// consistent with [InflationCalculator]'s gap-detection philosophy.
  Decimal? _realValue(
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

    final result = _inflationCalculator.calculateRealValue(
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

  Map<String, _TwoRecentPrices> _twoRecentPricesByCode(
    List<MarketPriceRow> rows,
  ) {
    final result = <String, _TwoRecentPrices>{};
    for (final row in rows) {
      final existing = result[row.assetTypeCode];
      if (existing == null) {
        result[row.assetTypeCode] = _TwoRecentPrices(
          latest: row.price,
          previous: null,
        );
      } else if (existing.previous == null) {
        result[row.assetTypeCode] = _TwoRecentPrices(
          latest: existing.latest,
          previous: row.price,
        );
      }
    }
    return result;
  }
}

class _TwoRecentPrices {
  const _TwoRecentPrices({required this.latest, required this.previous});

  final Decimal latest;

  /// Null when fewer than two distinct price dates exist for the type.
  final Decimal? previous;
}

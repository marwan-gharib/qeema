import 'package:decimal/decimal.dart';
import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/extensions/decimal_extensions.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_market_price_history_usecase.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';
import 'package:qeema/features/market_prices/domain/repositories/market_prices_repository.dart';

class MarketPricesRepositoryImpl implements MarketPricesRepository {
  MarketPricesRepositoryImpl(
    this._getAssetTypesUseCase,
    this._getPriceHistoryUseCase, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final GetAssetTypesUseCase _getAssetTypesUseCase;
  final GetMarketPriceHistoryUseCase _getPriceHistoryUseCase;
  final DateTime Function() _now;

  /// In-memory TTL cache per type code (DATA-8: caching policy lives here).
  /// Request de-duplication: the list screen, the detail screen and range
  /// changes all share one history read per type within the TTL window.
  final _historyCache =
      <String, ({DateTime fetchedAt, List<MarketPriceEntity> rows})>{};

  @override
  Future<ApiResult<List<MarketPriceSummaryEntity>>> getSummaries({
    bool forceRefresh = false,
  }) async {
    final typesResult = await _getAssetTypesUseCase.call();
    return typesResult.fold(
      onSuccess: (types) => _buildSummaries(
        types.where((t) => t.isMarketBased).toList(),
        forceRefresh: forceRefresh,
      ),
      onFailure: (failure) async => ResultFailure(failure),
    );
  }

  Future<ApiResult<List<MarketPriceSummaryEntity>>> _buildSummaries(
    List<AssetTypeEntity> marketTypes, {
    required bool forceRefresh,
  }) async {
    final summaries = <MarketPriceSummaryEntity>[];
    Failure? firstFailure;
    for (final type in marketTypes) {
      final result = await _history(type.code, forceRefresh: forceRefresh);
      final history = result.fold<List<MarketPriceEntity>?>(
        onSuccess: (rows) => rows,
        onFailure: (failure) {
          firstFailure ??= failure;
          return null;
        },
      );
      if (history == null) continue;
      summaries.add(_toSummary(type, history));
    }
    if (summaries.isEmpty && firstFailure != null) {
      return ResultFailure(firstFailure!);
    }
    return Success(summaries);
  }

  /// TTL-cached history read. On a failed refetch a stale entry is served —
  /// an old chart beats an error when the network is down.
  Future<ApiResult<List<MarketPriceEntity>>> _history(
    String assetTypeCode, {
    required bool forceRefresh,
  }) async {
    final cached = _historyCache[assetTypeCode];
    if (!forceRefresh &&
        cached != null &&
        _now().difference(cached.fetchedAt) <
            AppConstants.marketPriceCacheDuration) {
      return Success(cached.rows);
    }

    final result = await _getPriceHistoryUseCase.call(assetTypeCode);
    return result.fold(
      onSuccess: (rows) {
        _historyCache[assetTypeCode] = (fetchedAt: _now(), rows: rows);
        return Success(rows);
      },
      onFailure: (failure) =>
          cached != null ? Success(cached.rows) : ResultFailure(failure),
    );
  }

  MarketPriceSummaryEntity _toSummary(
    AssetTypeEntity type,
    List<MarketPriceEntity> history,
  ) {
    final latest = history.isEmpty ? null : history.last;
    final weeklyChange = latest == null
        ? null
        : _weeklyChange(
            latest.price,
            history,
            latest.priceDate.subtract(const Duration(days: 7)),
          );

    final sparklineStart = history.length <= 7 ? 0 : history.length - 7;

    return MarketPriceSummaryEntity(
      assetType: type,
      todayPrice: latest?.price,
      todayPriceDate: latest?.priceDate,
      fetchedAt: latest?.fetchedAt,
      weeklyChangePercent: weeklyChange,
      sparklinePoints: history
          .sublist(sparklineStart)
          .map(MarketPricePointEntity.fromMarketPrice)
          .toList(),
    );
  }

  Decimal? _weeklyChange(
    Decimal latestPrice,
    List<MarketPriceEntity> history,
    DateTime weekAgo,
  ) {
    // Nearest row on or before the target date — gaps are possible depending
    // on the cron's run history, so an exact-7-days-ago row is not guaranteed.
    MarketPriceEntity? weekAgoRow;
    for (final row in history.reversed) {
      if (!row.priceDate.isAfter(weekAgo)) {
        weekAgoRow = row;
        break;
      }
    }
    if (weekAgoRow == null || weekAgoRow.price == Decimal.zero) return null;
    return (latestPrice - weekAgoRow.price).divideBy(weekAgoRow.price) *
        Decimal.fromInt(100);
  }

  @override
  Future<ApiResult<List<MarketPricePointEntity>>> getRange({
    required String assetTypeCode,
    required DateTime from,
    required DateTime to,
  }) async {
    final result = await _history(assetTypeCode, forceRefresh: false);
    return result.fold(
      onSuccess: (history) => Success(
        history
            .where(
              (row) =>
                  !row.priceDate.isBefore(from) && !row.priceDate.isAfter(to),
            )
            .map(MarketPricePointEntity.fromMarketPrice)
            .toList(),
      ),
      onFailure: (failure) => ResultFailure(failure),
    );
  }
}

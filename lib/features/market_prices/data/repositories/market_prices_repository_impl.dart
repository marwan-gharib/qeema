import 'package:decimal/decimal.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/extensions/decimal_extensions.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_market_price_history_usecase.dart';
import 'package:qeema/features/market_prices/data/mappers/market_price_point_mapper.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';
import 'package:qeema/features/market_prices/domain/repositories/market_prices_repository.dart';

class MarketPricesRepositoryImpl implements MarketPricesRepository {
  MarketPricesRepositoryImpl(
    this._getAssetTypesUseCase,
    this._getPriceHistoryUseCase,
  );

  final GetAssetTypesUseCase _getAssetTypesUseCase;
  final GetMarketPriceHistoryUseCase _getPriceHistoryUseCase;

  @override
  Future<ApiResult<List<MarketPriceSummaryEntity>>> getSummaries() async {
    final typesResult = await _getAssetTypesUseCase.call();
    return typesResult.fold(
      onSuccess: (types) =>
          _buildSummaries(types.where((t) => t.isMarketBased).toList()),
      onFailure: (failure) async => ResultFailure(failure),
    );
  }

  Future<ApiResult<List<MarketPriceSummaryEntity>>> _buildSummaries(
    List<AssetTypeEntity> marketTypes,
  ) async {
    final summaries = <MarketPriceSummaryEntity>[];
    Failure? firstFailure;
    for (final type in marketTypes) {
      final result = await _getPriceHistoryUseCase.call(type.code);
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
          .map(MarketPricePointMapper.fromMarketPrice)
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
    final result = await _getPriceHistoryUseCase.call(assetTypeCode);
    return result.fold(
      onSuccess: (history) => Success(
        history
            .where(
              (row) =>
                  !row.priceDate.isBefore(from) && !row.priceDate.isAfter(to),
            )
            .map(MarketPricePointMapper.fromMarketPrice)
            .toList(),
      ),
      onFailure: (failure) => ResultFailure(failure),
    );
  }
}

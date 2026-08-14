import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_market_price_history_usecase.dart';
import 'package:qeema/features/market_prices/data/repositories/market_prices_repository_impl.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';

const _usdType = AssetTypeEntity(
  id: 'type-usd',
  code: 'usd',
  name: 'US Dollar',
  isMarketBased: true,
  baseUnit: 'USD',
);

const _goldType = AssetTypeEntity(
  id: 'type-gold',
  code: 'gold_21',
  name: 'Gold 21K',
  isMarketBased: true,
  baseUnit: 'gram',
);

const _egpType = AssetTypeEntity(
  id: 'type-egp',
  code: 'cash_egp',
  name: 'Cash (EGP)',
  isMarketBased: false,
  baseUnit: 'EGP',
);

class MockGetAssetTypesUseCase implements GetAssetTypesUseCase {
  ApiResult<List<AssetTypeEntity>> result = const Success([]);
  int callCount = 0;

  @override
  Future<ApiResult<List<AssetTypeEntity>>> call() async {
    callCount++;
    return result;
  }
}

class MockGetMarketPriceHistoryUseCase implements GetMarketPriceHistoryUseCase {
  ApiResult<List<MarketPriceEntity>> result = const Success([]);
  Map<String, ApiResult<List<MarketPriceEntity>>> resultForCode = {};
  final List<String> requestedCodes = [];

  @override
  Future<ApiResult<List<MarketPriceEntity>>> call(String assetTypeCode) async {
    requestedCodes.add(assetTypeCode);
    return resultForCode[assetTypeCode] ?? result;
  }
}

MarketPriceEntity _price(String date, String value, {DateTime? fetchedAt}) {
  return MarketPriceEntity(
    priceDate: DateTime.parse(date),
    price: Decimal.parse(value),
    fetchedAt: fetchedAt,
  );
}

/// 14 daily rows ending 2026-08-14, starting at 100 with a steady rise.
List<MarketPriceEntity> _dailyHistory({DateTime? fetchedAt}) {
  return [
    for (var i = 0; i < 14; i++)
      _price(
        '2026-08-${(1 + i).toString().padLeft(2, '0')}',
        (100.0 + i * 2).toString(),
        fetchedAt: fetchedAt,
      ),
  ];
}

void main() {
  late MockGetAssetTypesUseCase typesUseCase;
  late MockGetMarketPriceHistoryUseCase historyUseCase;
  late MarketPricesRepositoryImpl repository;

  setUp(() {
    typesUseCase = MockGetAssetTypesUseCase();
    historyUseCase = MockGetMarketPriceHistoryUseCase();
    repository = MarketPricesRepositoryImpl(typesUseCase, historyUseCase);
  });

  group('getSummaries', () {
    test('filters to market-based types and computes weekly change', () async {
      typesUseCase.result = const Success([_usdType, _goldType, _egpType]);
      // 7 days before 2026-08-14 is 2026-08-07 (100 + 6*2 = 112).
      historyUseCase.result = Success(_dailyHistory());

      final result = await repository.getSummaries();

      expect(historyUseCase.requestedCodes, ['usd', 'gold_21']);
      final summaries = (result as Success).data;
      expect(summaries.length, 2);
      final usd = summaries.firstWhere(
        (MarketPriceSummaryEntity s) => s.assetType.code == 'usd',
      );
      expect(usd.todayPrice, Decimal.parse('126'));
      expect(usd.weeklyChangePercent, Decimal.parse('12.5'));
      expect(usd.sparklinePoints.length, 7);
      expect(usd.sparklinePoints.first.date, DateTime.parse('2026-08-08'));
    });

    test(
      'nearest-prior row is used when no exact 7-days-ago row exists',
      () async {
        typesUseCase.result = const Success([_usdType]);
        // Missing 2026-08-07 and 2026-08-08 — nearest prior is 2026-08-06.
        historyUseCase.result = Success([
          _price('2026-08-01', '100'),
          _price('2026-08-02', '100'),
          _price('2026-08-03', '100'),
          _price('2026-08-04', '100'),
          _price('2026-08-05', '100'),
          _price('2026-08-06', '100'),
          _price('2026-08-09', '110'),
          _price('2026-08-10', '120'),
          _price('2026-08-11', '130'),
          _price('2026-08-12', '140'),
          _price('2026-08-13', '150'),
          _price('2026-08-14', '160'),
        ]);

        final result = await repository.getSummaries();
        final summary = ((result as Success).data).single;
        // (160 - 100) / 100 = 60%
        expect(summary.weeklyChangePercent, Decimal.parse('60'));
      },
    );

    test('weekly change is null when history is shorter than 7 days', () async {
      typesUseCase.result = const Success([_usdType]);
      historyUseCase.result = Success([
        _price('2026-08-10', '100'),
        _price('2026-08-11', '110'),
        _price('2026-08-12', '120'),
      ]);

      final result = await repository.getSummaries();
      final summary = ((result as Success).data).single;
      expect(summary.weeklyChangePercent, isNull);
      expect(summary.sparklinePoints.length, 3);
    });

    test('carries fetchedAt from the latest row for staleness', () async {
      typesUseCase.result = const Success([_usdType]);
      final fetchedAt = DateTime(2026, 8, 14, 6, 0, 0);
      historyUseCase.result = Success(
        _dailyHistory(fetchedAt: fetchedAt).map((e) {
          return MarketPriceEntity(
            priceDate: e.priceDate,
            price: e.price,
            fetchedAt: fetchedAt,
          );
        }).toList(),
      );

      final result = await repository.getSummaries();
      final summary = ((result as Success).data).single;
      expect(summary.fetchedAt, fetchedAt);
    });

    test('excludes a type whose history fetch fails, keeps the rest', () async {
      typesUseCase.result = const Success([_usdType, _goldType]);
      historyUseCase.resultForCode = {
        'usd': const ResultFailure(ServerFailure('down')),
      };

      final result = await repository.getSummaries();

      final summaries = (result as Success).data;
      expect(summaries.length, 1);
      expect(summaries.single.assetType.code, 'gold_21');
    });

    test('fails when all market types fail to fetch history', () async {
      typesUseCase.result = const Success([_usdType, _goldType]);
      historyUseCase.result = const ResultFailure(ServerFailure('down'));

      final result = await repository.getSummaries();

      expect(result, isA<ResultFailure<List<MarketPriceSummaryEntity>>>());
    });

    test('fails when the asset types fetch fails', () async {
      typesUseCase.result = const ResultFailure(CacheFailure('no cache'));

      final result = await repository.getSummaries();

      expect(result, isA<ResultFailure<List<MarketPriceSummaryEntity>>>());
      (result as ResultFailure).fold(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (failure) => expect(failure, isA<CacheFailure>()),
      );
    });

    test('succeeds with empty list when no market-based types exist', () async {
      typesUseCase.result = const Success([_egpType]);

      final result = await repository.getSummaries();

      expect(historyUseCase.requestedCodes, isEmpty);
      expect(((result as Success).data), isEmpty);
    });
  });

  group('getRange', () {
    test('returns only points within the requested window', () async {
      historyUseCase.result = Success(_dailyHistory());

      final result = await repository.getRange(
        assetTypeCode: 'usd',
        from: DateTime.parse('2026-08-05'),
        to: DateTime.parse('2026-08-08'),
      );

      final points = (result as Success).data;
      expect(points.map((MarketPricePointEntity p) => p.date).toList(), [
        DateTime.parse('2026-08-05'),
        DateTime.parse('2026-08-06'),
        DateTime.parse('2026-08-07'),
        DateTime.parse('2026-08-08'),
      ]);
      expect(points.first.price, Decimal.parse('108'));
    });

    test('returns empty when no rows fall in the window', () async {
      historyUseCase.result = Success(_dailyHistory());

      final result = await repository.getRange(
        assetTypeCode: 'usd',
        from: DateTime.parse('2020-01-01'),
        to: DateTime.parse('2020-01-02'),
      );

      expect(((result as Success).data), isEmpty);
    });

    test('maps history fetch failure to ResultFailure', () async {
      historyUseCase.result = const ResultFailure(NetworkFailure('offline'));

      final result = await repository.getRange(
        assetTypeCode: 'usd',
        from: DateTime.parse('2026-08-01'),
        to: DateTime.parse('2026-08-14'),
      );

      expect(result, isA<ResultFailure<List<MarketPricePointEntity>>>());
    });
  });
}

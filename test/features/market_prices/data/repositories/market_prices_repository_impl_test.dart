import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/market_prices/data/repositories/market_prices_repository_impl.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';
import 'market_prices_repository_fixtures.dart';

void main() {
  late MockGetAssetTypesUseCase typesUseCase;
  late MockGetMarketPriceHistoryUseCase historyUseCase;
  late MarketPricesRepositoryImpl repository;
  var currentTime = DateTime(2026, 8, 14, 12);

  setUp(() {
    typesUseCase = MockGetAssetTypesUseCase();
    historyUseCase = MockGetMarketPriceHistoryUseCase();
    currentTime = DateTime(2026, 8, 14, 12);
    repository = MarketPricesRepositoryImpl(
      typesUseCase,
      historyUseCase,
      now: () => currentTime,
    );
  });

  group('getSummaries', () {
    test('filters to market-based types and computes weekly change', () async {
      typesUseCase.result = const Success([usdType, goldType, egpType]);
      // 7 days before 2026-08-14 is 2026-08-07 (100 + 6*2 = 112).
      historyUseCase.result = Success(dailyHistory());

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
        typesUseCase.result = const Success([usdType]);
        // Missing 2026-08-07 and 2026-08-08 â€” nearest prior is 2026-08-06.
        historyUseCase.result = Success([
          price('2026-08-01', '100'),
          price('2026-08-02', '100'),
          price('2026-08-03', '100'),
          price('2026-08-04', '100'),
          price('2026-08-05', '100'),
          price('2026-08-06', '100'),
          price('2026-08-09', '110'),
          price('2026-08-10', '120'),
          price('2026-08-11', '130'),
          price('2026-08-12', '140'),
          price('2026-08-13', '150'),
          price('2026-08-14', '160'),
        ]);

        final result = await repository.getSummaries();
        final summary = ((result as Success).data).single;
        // (160 - 100) / 100 = 60%
        expect(summary.weeklyChangePercent, Decimal.parse('60'));
      },
    );

    test('weekly change is null when history is shorter than 7 days', () async {
      typesUseCase.result = const Success([usdType]);
      historyUseCase.result = Success([
        price('2026-08-10', '100'),
        price('2026-08-11', '110'),
        price('2026-08-12', '120'),
      ]);

      final result = await repository.getSummaries();
      final summary = ((result as Success).data).single;
      expect(summary.weeklyChangePercent, isNull);
      expect(summary.sparklinePoints.length, 3);
    });

    test('carries fetchedAt from the latest row for staleness', () async {
      typesUseCase.result = const Success([usdType]);
      final fetchedAt = DateTime(2026, 8, 14, 6, 0, 0);
      historyUseCase.result = Success(
        dailyHistory(fetchedAt: fetchedAt).map((e) {
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
      typesUseCase.result = const Success([usdType, goldType]);
      historyUseCase.resultForCode = {
        'usd': const ResultFailure(ServerFailure('down')),
      };

      final result = await repository.getSummaries();

      final summaries = (result as Success).data;
      expect(summaries.length, 1);
      expect(summaries.single.assetType.code, 'gold_21');
    });

    test('fails when all market types fail to fetch history', () async {
      typesUseCase.result = const Success([usdType, goldType]);
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
      typesUseCase.result = const Success([egpType]);

      final result = await repository.getSummaries();

      expect(historyUseCase.requestedCodes, isEmpty);
      expect(((result as Success).data), isEmpty);
    });
  });

  group('getRange', () {
    test('returns only points within the requested window', () async {
      historyUseCase.result = Success(dailyHistory());

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
      historyUseCase.result = Success(dailyHistory());

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

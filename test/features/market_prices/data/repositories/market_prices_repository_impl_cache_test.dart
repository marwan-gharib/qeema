import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/market_prices/data/repositories/market_prices_repository_impl.dart';
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

  group('TTL cache', () {
    test(
      'should serve a second read from the cache within the TTL window',
      () async {
        typesUseCase.result = const Success([usdType]);
        historyUseCase.result = Success(dailyHistory());

        await repository.getSummaries();
        await repository.getSummaries();

        expect(historyUseCase.requestedCodes, ['usd']);
      },
    );

    test('should refetch when forceRefresh is true', () async {
      typesUseCase.result = const Success([usdType]);
      historyUseCase.result = Success(dailyHistory());

      await repository.getSummaries();
      await repository.getSummaries(forceRefresh: true);

      expect(historyUseCase.requestedCodes, ['usd', 'usd']);
    });

    test('should refetch once the TTL window has passed', () async {
      typesUseCase.result = const Success([usdType]);
      historyUseCase.result = Success(dailyHistory());

      await repository.getSummaries();
      currentTime = currentTime.add(const Duration(hours: 13));
      await repository.getSummaries();

      expect(historyUseCase.requestedCodes, ['usd', 'usd']);
    });

    test('should serve a stale entry when a refetch fails', () async {
      typesUseCase.result = const Success([usdType]);
      historyUseCase.result = Success(dailyHistory());
      await repository.getSummaries();

      historyUseCase.result = const ResultFailure(ServerFailure('down'));
      final result = await repository.getSummaries(forceRefresh: true);

      expect(result, isA<Success<List<MarketPriceSummaryEntity>>>());
      expect(
        (result as Success<List<MarketPriceSummaryEntity>>)
            .data
            .single
            .todayPrice,
        Decimal.parse('126'),
      );
    });

    test(
      'should share the cached history with getRange for the same type',
      () async {
        typesUseCase.result = const Success([usdType]);
        historyUseCase.result = Success(dailyHistory());

        await repository.getSummaries();
        final result = await repository.getRange(
          assetTypeCode: 'usd',
          from: DateTime.parse('2026-08-05'),
          to: DateTime.parse('2026-08-08'),
        );

        expect(historyUseCase.requestedCodes, ['usd']);
        expect((result as Success).data.length, 4);
      },
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';
import 'package:qeema/features/market_prices/domain/repositories/market_prices_repository.dart';
import 'package:qeema/features/market_prices/domain/usecases/get_market_price_summaries_usecase.dart';

class MockMarketPricesRepository implements MarketPricesRepository {
  ApiResult<List<MarketPriceSummaryEntity>> summariesResult = const Success([]);
  bool? lastForceRefresh;

  @override
  Future<ApiResult<List<MarketPriceSummaryEntity>>> getSummaries({
    bool forceRefresh = false,
  }) async {
    lastForceRefresh = forceRefresh;
    return summariesResult;
  }

  @override
  Future<ApiResult<List<MarketPricePointEntity>>> getRange({
    required String assetTypeCode,
    required DateTime from,
    required DateTime to,
  }) => throw UnimplementedError();
}

void main() {
  late MockMarketPricesRepository repository;
  late GetMarketPriceSummariesUseCase useCase;

  setUp(() {
    repository = MockMarketPricesRepository();
    useCase = GetMarketPriceSummariesUseCase(repository);
  });

  test(
    'should default to a cache-tolerant read (forceRefresh false)',
    () async {
      final result = await useCase();

      expect(result, isA<Success<List<MarketPriceSummaryEntity>>>());
      expect(repository.lastForceRefresh, isFalse);
    },
  );

  test('should forward forceRefresh to the repository', () async {
    await useCase(forceRefresh: true);

    expect(repository.lastForceRefresh, isTrue);
  });

  test('should return the repository failure unchanged', () async {
    repository.summariesResult = const ResultFailure(UnknownFailure());

    final result = await useCase();

    expect(result, isA<ResultFailure<List<MarketPriceSummaryEntity>>>());
  });
}

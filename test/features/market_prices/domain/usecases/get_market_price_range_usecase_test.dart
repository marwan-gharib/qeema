import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';
import 'package:qeema/features/market_prices/domain/params/get_market_price_range_params.dart';
import 'package:qeema/features/market_prices/domain/repositories/market_prices_repository.dart';
import 'package:qeema/features/market_prices/domain/usecases/get_market_price_range_usecase.dart';

class CapturedRangeCall {
  CapturedRangeCall(this.assetTypeCode, this.from, this.to);
  final String assetTypeCode;
  final DateTime from;
  final DateTime to;
}

class MockMarketPricesRepository implements MarketPricesRepository {
  ApiResult<List<MarketPricePointEntity>> rangeResult = const Success([]);
  final List<CapturedRangeCall> calls = [];

  @override
  Future<ApiResult<List<MarketPriceSummaryEntity>>> getSummaries({
    bool forceRefresh = false,
  }) => throw UnimplementedError();

  @override
  Future<ApiResult<List<MarketPricePointEntity>>> getRange({
    required String assetTypeCode,
    required DateTime from,
    required DateTime to,
  }) async {
    calls.add(CapturedRangeCall(assetTypeCode, from, to));
    return rangeResult;
  }
}

void main() {
  late MockMarketPricesRepository repository;
  late GetMarketPriceRangeUseCase useCase;

  setUp(() {
    repository = MockMarketPricesRepository();
    useCase = GetMarketPriceRangeUseCase(repository);
  });

  test('should forward code and window to repository.getRange', () async {
    final from = DateTime(2026, 8, 1);
    final to = DateTime(2026, 8, 14);

    final result = await useCase(
      GetMarketPriceRangeParams(assetTypeCode: 'usd', from: from, to: to),
    );

    expect(result, isA<Success<List<MarketPricePointEntity>>>());
    expect(repository.calls.single.assetTypeCode, 'usd');
    expect(repository.calls.single.from, from);
    expect(repository.calls.single.to, to);
  });

  test('should return the repository failure unchanged', () async {
    repository.rangeResult = const ResultFailure(UnknownFailure());

    final result = await useCase(
      GetMarketPriceRangeParams(
        assetTypeCode: 'usd',
        from: DateTime(2026, 8, 1),
        to: DateTime(2026, 8, 14),
      ),
    );

    expect(result, isA<ResultFailure<List<MarketPricePointEntity>>>());
  });
}

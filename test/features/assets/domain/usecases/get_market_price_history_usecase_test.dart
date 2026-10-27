import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/usecases/get_market_price_history_usecase.dart';
import 'mocks/mock_assets_repository.dart';

void main() {
  late MockAssetsRepository repository;
  late GetMarketPriceHistoryUseCase useCase;

  setUp(() {
    repository = MockAssetsRepository();
    useCase = GetMarketPriceHistoryUseCase(repository);
  });

  test(
    'should delegate to repository.getPriceHistory and return its success',
    () async {
      final result = await useCase('usd');

      expect(result, isA<Success<dynamic>>());
    },
  );

  test('should return the repository failure unchanged', () async {
    repository.getPriceHistoryResult = const ResultFailure(UnknownFailure());

    final result = await useCase('usd');

    expect(result, isA<ResultFailure<dynamic>>());
  });
}

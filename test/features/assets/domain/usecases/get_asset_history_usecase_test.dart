import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_history_usecase.dart';
import 'mocks/mock_assets_repository.dart';

void main() {
  late MockAssetsRepository repository;
  late GetAssetHistoryUseCase useCase;

  setUp(() {
    repository = MockAssetsRepository();
    useCase = GetAssetHistoryUseCase(repository);
  });

  test(
    'should delegate to repository.getAssetHistory and return its success',
    () async {
      final result = await useCase('a1');

      expect(result, isA<Success<dynamic>>());
    },
  );

  test('should return the repository failure unchanged', () async {
    repository.getAssetHistoryResult = const ResultFailure(UnknownFailure());

    final result = await useCase('a1');

    expect(result, isA<ResultFailure<dynamic>>());
  });
}

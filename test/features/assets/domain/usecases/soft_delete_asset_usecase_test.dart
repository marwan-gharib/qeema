import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/usecases/soft_delete_asset_usecase.dart';
import 'mocks/mock_assets_repository.dart';

void main() {
  late MockAssetsRepository repository;
  late SoftDeleteAssetUseCase useCase;

  setUp(() {
    repository = MockAssetsRepository();
    useCase = SoftDeleteAssetUseCase(repository);
  });

  test(
    'should delegate to repository.softDeleteAsset and return its success',
    () async {
      final result = await useCase('a1');

      expect(result, isA<Success<void>>());
    },
  );

  test('should return the repository failure unchanged', () async {
    repository.softDeleteAssetResult = const ResultFailure(UnknownFailure());

    final result = await useCase('a1');

    expect(result, isA<ResultFailure<void>>());
  });
}

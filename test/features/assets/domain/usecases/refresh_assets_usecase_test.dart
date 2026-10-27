import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/usecases/refresh_assets_usecase.dart';
import 'mocks/mock_assets_repository.dart';

void main() {
  late MockAssetsRepository repository;
  late RefreshAssetsUseCase useCase;

  setUp(() {
    repository = MockAssetsRepository();
    useCase = RefreshAssetsUseCase(repository);
  });

  test(
    'should delegate to repository.refreshAssets and return its success',
    () async {
      final result = await useCase();

      expect(result, isA<Success<List<AssetEntity>>>());
    },
  );

  test('should return the repository failure unchanged', () async {
    repository.getAssetsResult = const ResultFailure(UnknownFailure());

    final result = await useCase();

    expect(result, isA<ResultFailure<List<AssetEntity>>>());
  });
}

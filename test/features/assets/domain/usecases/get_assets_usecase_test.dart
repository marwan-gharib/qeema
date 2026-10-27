import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'mocks/mock_assets_repository.dart';

void main() {
  late MockAssetsRepository repository;
  late GetAssetsUseCase useCase;

  setUp(() {
    repository = MockAssetsRepository();
    useCase = GetAssetsUseCase(repository);
  });

  test('should return the repository success unchanged', () async {
    final result = await useCase();

    expect(result, isA<Success<List<AssetEntity>>>());
    expect((result as Success<List<AssetEntity>>).data, isEmpty);
  });

  test('should return the repository failure unchanged', () async {
    repository.getAssetsResult = const ResultFailure(UnknownFailure());

    final result = await useCase();

    expect(result, isA<ResultFailure<List<AssetEntity>>>());
    (result as ResultFailure<List<AssetEntity>>).fold(
      onSuccess: (_) => fail('Expected failure'),
      onFailure: (Failure failure) => expect(failure, isA<UnknownFailure>()),
    );
  });
}

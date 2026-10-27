import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'mocks/mock_assets_repository.dart';

const _type = AssetTypeEntity(
  id: 'type-1',
  code: 'usd',
  name: 'US Dollar',
  isMarketBased: true,
  baseUnit: 'USD',
);

void main() {
  late MockAssetsRepository repository;
  late GetAssetTypesUseCase useCase;

  setUp(() {
    repository = MockAssetsRepository();
    useCase = GetAssetTypesUseCase(repository);
  });

  test('should return the repository success unchanged', () async {
    repository.getAssetTypesResult = const Success([_type]);

    final result = await useCase();

    expect(result, isA<Success<List<AssetTypeEntity>>>());
    expect((result as Success<List<AssetTypeEntity>>).data.single, _type);
  });

  test('should return the repository failure unchanged', () async {
    repository.getAssetTypesResult = const ResultFailure(UnknownFailure());

    final result = await useCase();

    expect(result, isA<ResultFailure<List<AssetTypeEntity>>>());
  });
}

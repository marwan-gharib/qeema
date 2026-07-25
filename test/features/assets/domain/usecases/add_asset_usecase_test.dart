import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:qeema/features/assets/domain/usecases/add_asset_usecase.dart';

class MockAssetsRepository implements AssetsRepository {
  ApiResult<List<AssetEntity>> getAssetsResult = const Success([]);
  ApiResult<List<AssetTypeEntity>> getAssetTypesResult = const Success([]);
  ApiResult<AssetEntity> addAssetResult = Success(
    AssetEntity(
      id: 'test-id',
      assetType: AssetType.egpCash,
      amount: 100,
      priceAtEntry: 1,
      entryDate: DateTime(2026, 7, 25),
    ),
  );

  @override
  Future<ApiResult<List<AssetEntity>>> getAssets() async => getAssetsResult;

  @override
  Future<ApiResult<List<AssetTypeEntity>>> getAssetTypes() async =>
      getAssetTypesResult;

  @override
  Future<ApiResult<AssetEntity>> addAsset(AddAssetParams params) async =>
      addAssetResult;
}

void main() {
  late MockAssetsRepository mockRepository;
  late AddAssetUseCase useCase;

  setUp(() {
    mockRepository = MockAssetsRepository();
    useCase = AddAssetUseCase(mockRepository);
  });

  test('delegates to repository and returns success', () async {
    final result = await useCase.call(
      AddAssetParams(
        assetTypeId: 'type-1',
        amount: Decimal.parse('100'),
        priceAtEntry: Decimal.parse('50'),
        entryDate: DateTime(2026, 7, 25),
      ),
    );

    expect(result, isA<Success<AssetEntity>>());
    final entity = (result as Success).data;
    expect(entity.amount, 100);
    expect(entity.priceAtEntry, 1);
  });

  test('delegates to repository and returns failure', () async {
    mockRepository.addAssetResult = const ResultFailure(ServerFailure('error'));

    final result = await useCase.call(
      AddAssetParams(
        assetTypeId: 'type-1',
        amount: Decimal.parse('100'),
        entryDate: DateTime(2026, 7, 25),
      ),
    );

    expect(result, isA<ResultFailure<AssetEntity>>());
  });
}

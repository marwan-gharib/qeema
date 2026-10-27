import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/usecases/add_asset_usecase.dart';
import 'mocks/mock_assets_repository.dart';

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

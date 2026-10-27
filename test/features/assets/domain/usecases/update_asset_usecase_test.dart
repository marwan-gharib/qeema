import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'package:qeema/features/assets/domain/usecases/update_asset_usecase.dart';
import 'mocks/mock_assets_repository.dart';

void main() {
  late MockAssetsRepository repository;
  late UpdateAssetUseCase useCase;

  setUp(() {
    repository = MockAssetsRepository();
    useCase = UpdateAssetUseCase(repository);
  });

  test(
    'should delegate to repository.updateAsset and return its success',
    () async {
      final params = UpdateAssetParams(
        assetId: 'a1',
        amount: Decimal.parse('300'),
        entryDate: DateTime(2026, 7, 25),
      );

      final result = await useCase(params);

      expect(result, isA<Success<AssetEntity>>());
      expect((result as Success<AssetEntity>).data.amount, 200);
    },
  );

  test('should return the repository failure unchanged', () async {
    repository.updateAssetResult = const ResultFailure(UnknownFailure());

    final result = await useCase(
      UpdateAssetParams(
        assetId: 'a1',
        amount: Decimal.parse('300'),
        entryDate: DateTime(2026, 7, 25),
      ),
    );

    expect(result, isA<ResultFailure<AssetEntity>>());
  });
}

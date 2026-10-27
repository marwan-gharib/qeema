import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/domain/asset_type.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/update_asset_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/edit_asset_cubit/edit_asset_cubit.dart';

class MockGetAssetsUseCase implements GetAssetsUseCase {
  ApiResult<List<AssetEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<AssetEntity>>> call() async => result;

  @override
  AssetsRepository get repository => throw UnimplementedError();
}

class MockUpdateAssetUseCase implements UpdateAssetUseCase {
  ApiResult<AssetEntity> result = Success(
    AssetEntity(
      id: 'a1',
      assetType: AssetType.egpCash,
      amount: 300,
      priceAtEntry: 1,
      entryDate: DateTime(2026, 7, 25),
    ),
  );

  @override
  Future<ApiResult<AssetEntity>> call(UpdateAssetParams params) async => result;
}

final _asset = AssetEntity(
  id: 'a1',
  assetType: AssetType.egpCash,
  amount: 100,
  priceAtEntry: 1,
  entryDate: DateTime(2026, 7, 25),
  note: 'rent money',
);

Future<EditAssetCubit> _pumpCubit(
  MockGetAssetsUseCase getAssets,
  MockUpdateAssetUseCase updateAsset,
) async {
  final cubit = EditAssetCubit(
    assetId: 'a1',
    getAssets: getAssets,
    updateAsset: updateAsset,
  );
  // The constructor kicks off loadAsset asynchronously.
  await Future<void>.delayed(Duration.zero);
  return cubit;
}

void main() {
  late MockGetAssetsUseCase getAssets;
  late MockUpdateAssetUseCase updateAsset;

  setUp(() {
    getAssets = MockGetAssetsUseCase();
    updateAsset = MockUpdateAssetUseCase();
  });

  test('loads the matching asset into the form state', () async {
    getAssets.result = Success([_asset]);

    final cubit = await _pumpCubit(getAssets, updateAsset);
    addTearDown(cubit.close);

    final state = cubit.state;
    expect(state.isLoading, isFalse);
    expect(state.originalAsset, _asset);
    expect(state.amount, Decimal.parse('100'));
    expect(state.entryDate, DateTime(2026, 7, 25));
    expect(state.note, 'rent money');
    expect(state.isFormValid, isTrue);
  });

  test('emits AssetNotFoundFailure when the asset id does not exist', () async {
    getAssets.result = const Success([]);

    final cubit = await _pumpCubit(getAssets, updateAsset);
    addTearDown(cubit.close);

    expect(cubit.state.loadFailure, isA<AssetNotFoundFailure>());
  });

  test('emits the load failure when the usecase fails', () async {
    getAssets.result = const ResultFailure(UnknownFailure());

    final cubit = await _pumpCubit(getAssets, updateAsset);
    addTearDown(cubit.close);

    expect(cubit.state.loadFailure, isA<UnknownFailure>());
  });

  test('hasChanges is false right after loading the asset', () async {
    getAssets.result = Success([_asset]);
    final cubit = await _pumpCubit(getAssets, updateAsset);
    addTearDown(cubit.close);

    expect(cubit.state.hasChanges, isFalse);
  });

  test('a changed amount counts as a change', () async {
    getAssets.result = Success([_asset]);
    final cubit = await _pumpCubit(getAssets, updateAsset);
    addTearDown(cubit.close);

    cubit.updateAmount(Decimal.parse('300'));

    expect(cubit.state.hasChanges, isTrue);
  });

  test(
    'a blank note normalizes to null (no change vs a null original note)',
    () async {
      getAssets.result = Success([
        AssetEntity(
          id: 'a1',
          assetType: AssetType.egpCash,
          amount: 100,
          priceAtEntry: 1,
          entryDate: DateTime(2026, 7, 25),
        ),
      ]);
      final cubit = await _pumpCubit(getAssets, updateAsset);
      addTearDown(cubit.close);

      cubit.updateNote('   ');

      expect(cubit.state.hasChanges, isFalse);
    },
  );

  test('entry date compares by year/month/day only', () async {
    getAssets.result = Success([_asset]);
    final cubit = await _pumpCubit(getAssets, updateAsset);
    addTearDown(cubit.close);

    cubit.updateEntryDate(DateTime(2026, 7, 25, 23, 30));

    expect(cubit.state.hasChanges, isFalse);
  });

  test(
    'submit success flags submitSucceeded with the updated entity',
    () async {
      getAssets.result = Success([_asset]);
      final cubit = await _pumpCubit(getAssets, updateAsset);
      addTearDown(cubit.close);

      await cubit.submit(
        UpdateAssetParams(
          assetId: 'a1',
          amount: Decimal.parse('300'),
          entryDate: DateTime(2026, 7, 25),
        ),
      );

      final state = cubit.state;
      expect(state.isSubmitting, isFalse);
      expect(state.submitSucceeded, isTrue);
      expect(state.updatedEntity!.amount, 300);
    },
  );

  test(
    'submit failure keeps the submitting flag down and reports the failure',
    () async {
      updateAsset.result = const ResultFailure(UnknownFailure());
      getAssets.result = Success([_asset]);
      final cubit = await _pumpCubit(getAssets, updateAsset);
      addTearDown(cubit.close);

      await cubit.submit(
        UpdateAssetParams(
          assetId: 'a1',
          amount: Decimal.parse('300'),
          entryDate: DateTime(2026, 7, 25),
        ),
      );

      final state = cubit.state;
      expect(state.isSubmitting, isFalse);
      expect(state.submitSucceeded, isFalse);
      expect(state.submitFailure, isA<UnknownFailure>());
    },
  );
}

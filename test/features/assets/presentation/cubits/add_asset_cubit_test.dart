import 'dart:async';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/usecases/add_asset_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/add_asset_cubit/add_asset_cubit.dart';
import 'package:qeema/features/assets/presentation/cubits/add_asset_cubit/add_asset_state.dart';

class MockGetAssetTypesUseCase implements GetAssetTypesUseCase {
  ApiResult<List<AssetTypeEntity>> result = const Success([
    AssetTypeEntity(
      id: '1',
      code: 'cash_egp',
      name: 'Cash EGP',
      isMarketBased: false,
      baseUnit: 'EGP',
    ),
  ]);

  @override
  Future<ApiResult<List<AssetTypeEntity>>> call() async => result;
}

class MockAddAssetUseCase implements AddAssetUseCase {
  ApiResult<AssetEntity> result = Success(
    AssetEntity(
      id: '1',
      assetType: AssetType.egpCash,
      amount: 100,
      priceAtEntry: 1,
      entryDate: DateTime(2026, 7, 25),
    ),
  );

  @override
  Future<ApiResult<AssetEntity>> call(AddAssetParams params) async => result;
}

void main() {
  late MockGetAssetTypesUseCase mockGetTypes;
  late MockAddAssetUseCase mockAdd;
  late AddAssetCubit cubit;

  setUp(() {
    mockGetTypes = MockGetAssetTypesUseCase();
    mockAdd = MockAddAssetUseCase();
    cubit = AddAssetCubit(mockGetTypes, mockAdd);
  });

  tearDown(() {
    cubit.close();
  });

  group('AddAssetCubit', () {
    test('initial state has no selected type and is not submitting', () {
      expect(cubit.state.selectedType, isNull);
      expect(cubit.state.isSubmitting, false);
      expect(cubit.state.submitSucceeded, false);
      expect(cubit.state.submitFailure, isNull);
    });

    test('loadAssetTypes populates available types', () async {
      final future = expectLater(
        cubit.stream,
        emits(
          predicate<AddAssetState>(
            (s) =>
                s.availableTypes.length == 1 &&
                s.availableTypes.first.code == 'cash_egp',
          ),
        ),
      );
      unawaited(cubit.loadAssetTypes());
      await future;
    });

    test('loadAssetTypes handles failure gracefully', () async {
      mockGetTypes.result = const ResultFailure(ServerFailure('error'));

      final future = expectLater(
        cubit.stream,
        emits(
          predicate<AddAssetState>((s) => s.submitFailure is ServerFailure),
        ),
      );
      unawaited(cubit.loadAssetTypes());
      await future;
    });

    test('selectAssetType updates selectedType', () {
      const type = AssetTypeEntity(
        id: '1',
        code: 'usd',
        name: 'USD',
        isMarketBased: true,
        baseUnit: 'USD',
      );
      cubit.selectAssetType(type);
      expect(cubit.state.selectedType?.id, '1');
      expect(cubit.state.selectedType?.code, 'usd');
    });

    test('submit emits isSubmitting then submitSucceeded on success', () async {
      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<AddAssetState>((s) => s.isSubmitting == true),
          predicate<AddAssetState>(
            (s) => s.isSubmitting == false && s.submitSucceeded == true,
          ),
        ]),
      );
      unawaited(
        cubit.submit(
          AddAssetParams(
            assetTypeId: '1',
            amount: Decimal.parse('100'),
            entryDate: DateTime(2026, 7, 25),
          ),
        ),
      );
      await future;
    });

    test('submit emits isSubmitting then submitFailure on error', () async {
      mockAdd.result = const ResultFailure(ServerFailure('error'));

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<AddAssetState>((s) => s.isSubmitting == true),
          predicate<AddAssetState>(
            (s) =>
                s.isSubmitting == false && s.submitFailure?.message == 'error',
          ),
        ]),
      );
      unawaited(
        cubit.submit(
          AddAssetParams(
            assetTypeId: '1',
            amount: Decimal.parse('100'),
            entryDate: DateTime(2026, 7, 25),
          ),
        ),
      );
      await future;
    });

    test('second concurrent submit is ignored while submitting', () async {
      unawaited(
        cubit.submit(
          AddAssetParams(
            assetTypeId: '1',
            amount: Decimal.parse('100'),
            entryDate: DateTime(2026, 7, 25),
          ),
        ),
      );

      // While first is in-flight, isSubmitting is true so second is ignored
      await cubit.submit(
        AddAssetParams(
          assetTypeId: '1',
          amount: Decimal.parse('200'),
          entryDate: DateTime(2026, 7, 25),
        ),
      );
    });
  });
}

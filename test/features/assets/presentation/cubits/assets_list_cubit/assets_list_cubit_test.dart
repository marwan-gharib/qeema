import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/domain/asset_type.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/refresh_assets_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_cubit.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_state.dart';

class MockGetAssetsUseCase implements GetAssetsUseCase {
  ApiResult<List<AssetEntity>> result = const Success([]);
  int callCount = 0;

  @override
  Future<ApiResult<List<AssetEntity>>> call() async {
    callCount++;
    return result;
  }

  @override
  AssetsRepository get repository => throw UnimplementedError();
}

class MockRefreshAssetsUseCase implements RefreshAssetsUseCase {
  ApiResult<List<AssetEntity>> result = const Success([]);
  int callCount = 0;

  @override
  Future<ApiResult<List<AssetEntity>>> call() async {
    callCount++;
    return result;
  }

  @override
  AssetsRepository get repository => throw UnimplementedError();
}

void main() {
  final older = AssetEntity(
    id: 'old',
    assetType: AssetType.egpCash,
    amount: 100,
    priceAtEntry: 1,
    entryDate: DateTime(2026, 1, 1),
  );
  final newer = AssetEntity(
    id: 'new',
    assetType: AssetType.egpCash,
    amount: 200,
    priceAtEntry: 1,
    entryDate: DateTime(2026, 7, 1),
  );

  late MockGetAssetsUseCase getAssets;
  late MockRefreshAssetsUseCase refreshAssets;
  late AssetsListCubit cubit;

  setUp(() {
    getAssets = MockGetAssetsUseCase();
    refreshAssets = MockRefreshAssetsUseCase();
    cubit = AssetsListCubit(getAssets, refreshAssets);
  });

  tearDown(() => cubit.close());

  test(
    'loadAssets emits loading then loaded with the fetched assets',
    () async {
      getAssets.result = Success([older, newer]);

      final expected = expectLater(
        cubit.stream,
        emitsInOrder([isA<AssetsListLoading>(), isA<AssetsListLoaded>()]),
      );
      await cubit.loadAssets();
      await expected;

      expect(getAssets.callCount, 1);
      final state = cubit.state as AssetsListLoaded;
      // dateNewest default sort.
      expect(state.visibleAssets.map((a) => a.id), ['new', 'old']);
    },
  );

  test('loadAssets emits error when the usecase fails', () async {
    getAssets.result = const ResultFailure(UnknownFailure());

    final expected = expectLater(
      cubit.stream,
      emitsInOrder([isA<AssetsListLoading>(), isA<AssetsListError>()]),
    );
    await cubit.loadAssets();
    await expected;
  });

  test(
    'refresh delegates to RefreshAssetsUseCase without a Loading emission',
    () async {
      refreshAssets.result = Success([newer]);

      final expected = expectLater(
        cubit.stream,
        emitsInOrder([isA<AssetsListLoaded>()]),
      );
      await cubit.refresh();
      await expected;

      expect(refreshAssets.callCount, 1);
      expect(getAssets.callCount, 0);
    },
  );

  test('refresh emits error when the refresh fails', () async {
    refreshAssets.result = const ResultFailure(UnknownFailure());

    final expected = expectLater(
      cubit.stream,
      emitsInOrder([isA<AssetsListError>()]),
    );
    await cubit.refresh();
    await expected;
  });

  test('changeFilter narrows visibleAssets to the selected type', () async {
    getAssets.result = Success([
      older,
      AssetEntity(
        id: 'usd-1',
        assetType: AssetType.usdCash,
        amount: 10,
        priceAtEntry: 48,
        entryDate: DateTime(2026, 5, 1),
      ),
    ]);
    await cubit.loadAssets();

    cubit.changeFilter(AssetType.usdCash);

    final state = cubit.state as AssetsListLoaded;
    expect(state.activeFilter, AssetType.usdCash);
    expect(state.visibleAssets.single.id, 'usd-1');
  });

  test('changeFilter(null) clears the filter', () async {
    getAssets.result = Success([older]);
    await cubit.loadAssets();
    cubit.changeFilter(AssetType.egpCash);

    cubit.changeFilter(null);

    final state = cubit.state as AssetsListLoaded;
    expect(state.activeFilter, isNull);
  });

  test('changeSort reorders visibleAssets by value', () async {
    final cheap = AssetEntity(
      id: 'cheap',
      assetType: AssetType.egpCash,
      amount: 100,
      priceAtEntry: 1,
      entryDate: DateTime(2026, 1, 1),
      currentPrice: 1,
    );
    final dear = AssetEntity(
      id: 'dear',
      assetType: AssetType.egpCash,
      amount: 100,
      priceAtEntry: 1,
      entryDate: DateTime(2026, 2, 1),
      currentPrice: 500,
    );
    getAssets.result = Success([cheap, dear]);
    await cubit.loadAssets();

    cubit.changeSort(AssetsSortBy.valueHighest);

    final state = cubit.state as AssetsListLoaded;
    expect(state.visibleAssets.map((a) => a.id), ['dear', 'cheap']);
  });

  test('filter and sort calls on a non-loaded state are ignored', () async {
    // Initial state — must not throw.
    cubit.changeFilter(AssetType.egpCash);
    cubit.changeSort(AssetsSortBy.valueLowest);

    expect(cubit.state, isA<AssetsListInitial>());
  });
}

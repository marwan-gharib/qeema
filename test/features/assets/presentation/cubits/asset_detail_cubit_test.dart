import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_history_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_market_price_history_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/soft_delete_asset_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/asset_detail_cubit/asset_detail_cubit.dart';
import 'package:qeema/features/assets/presentation/cubits/asset_detail_cubit/asset_detail_state.dart';

final _usdAsset = AssetEntity(
  id: 'asset-1',
  assetType: AssetType.usdCash,
  amount: 300,
  priceAtEntry: 47.747,
  entryDate: DateTime(2026, 7, 20),
);

class MockGetAssetsUseCase implements GetAssetsUseCase {
  ApiResult<List<AssetEntity>> result = Success([_usdAsset]);

  @override
  Future<ApiResult<List<AssetEntity>>> call() async => result;

  @override
  AssetsRepository get repository => throw UnimplementedError();
}

class MockGetAssetHistoryUseCase implements GetAssetHistoryUseCase {
  ApiResult<List<AssetHistoryEntryEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<AssetHistoryEntryEntity>>> call(String assetId) async =>
      result;
}

class MockGetMarketPriceHistoryUseCase implements GetMarketPriceHistoryUseCase {
  String? requestedCode;
  ApiResult<List<MarketPriceEntity>> result = Success([
    MarketPriceEntity(
      priceDate: DateTime(2026, 7, 20),
      price: Decimal.parse('47.0'),
    ),
    MarketPriceEntity(
      priceDate: DateTime(2026, 7, 21),
      price: Decimal.parse('47.5'),
    ),
  ]);

  @override
  Future<ApiResult<List<MarketPriceEntity>>> call(String assetTypeCode) async {
    requestedCode = assetTypeCode;
    return result;
  }
}

class MockSoftDeleteAssetUseCase implements SoftDeleteAssetUseCase {
  ApiResult<void> result = const Success(null);

  @override
  Future<ApiResult<void>> call(String assetId) async => result;
}

void main() {
  late MockGetAssetsUseCase mockGetAssets;
  late MockGetAssetHistoryUseCase mockGetHistory;
  late MockGetMarketPriceHistoryUseCase mockGetPriceHistory;
  late MockSoftDeleteAssetUseCase mockSoftDelete;

  setUp(() {
    mockGetAssets = MockGetAssetsUseCase();
    mockGetHistory = MockGetAssetHistoryUseCase();
    mockGetPriceHistory = MockGetMarketPriceHistoryUseCase();
    mockSoftDelete = MockSoftDeleteAssetUseCase();
  });

  AssetDetailCubit buildCubit() {
    return AssetDetailCubit(
      assetId: 'asset-1',
      getAssets: mockGetAssets,
      getHistory: mockGetHistory,
      getPriceHistory: mockGetPriceHistory,
      softDelete: mockSoftDelete,
    );
  }

  Future<AssetDetailLoaded> loadUntilLoaded(AssetDetailCubit cubit) async {
    await expectLater(
      cubit.stream,
      emitsThrough(
        isA<AssetDetailLoaded>().having(
          (s) => s.asset.id,
          'asset id',
          'asset-1',
        ),
      ),
    );
    final state = cubit.state;
    expect(state, isA<AssetDetailLoaded>());
    return state as AssetDetailLoaded;
  }

  group('AssetDetailCubit price history', () {
    test('loads price history keyed to the asset type code', () async {
      final cubit = buildCubit();
      final loaded = await loadUntilLoaded(cubit);

      expect(mockGetPriceHistory.requestedCode, 'usd');
      expect(loaded.priceHistory.length, 2);
      expect(loaded.priceHistory.first.price, Decimal.parse('47.0'));
      await cubit.close();
    });

    test('falls back to empty price history when fetch fails', () async {
      mockGetPriceHistory.result = const ResultFailure(ServerFailure('error'));

      final cubit = buildCubit();
      final loaded = await loadUntilLoaded(cubit);

      expect(loaded.priceHistory, isEmpty);
      await cubit.close();
    });

    test('excludes price history before the asset entry date', () async {
      mockGetPriceHistory.result = Success([
        MarketPriceEntity(
          priceDate: DateTime(2026, 7, 10),
          price: Decimal.parse('45.0'),
        ),
        MarketPriceEntity(
          priceDate: DateTime(2026, 7, 20),
          price: Decimal.parse('47.0'),
        ),
        MarketPriceEntity(
          priceDate: DateTime(2026, 7, 21),
          price: Decimal.parse('47.5'),
        ),
      ]);

      final cubit = buildCubit();
      final loaded = await loadUntilLoaded(cubit);

      expect(loaded.priceHistory.map((p) => p.priceDate), [
        DateTime(2026, 7, 20),
        DateTime(2026, 7, 21),
      ]);
      await cubit.close();
    });

    test('keeps price history across applyUpdate', () async {
      final cubit = buildCubit();
      await loadUntilLoaded(cubit);

      cubit.applyUpdate(400, 50);

      expect(cubit.state, isA<AssetDetailLoaded>());
      final state = cubit.state as AssetDetailLoaded;
      expect(state.priceHistory.length, 2);
      expect(state.asset.amount, 400);
      await cubit.close();
    });
  });
}

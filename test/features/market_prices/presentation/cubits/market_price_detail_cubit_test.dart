import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';
import 'package:qeema/features/market_prices/domain/params/get_market_price_range_params.dart';
import 'package:qeema/features/market_prices/domain/usecases/get_market_price_range_usecase.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_price_detail_cubit/market_price_detail_cubit.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_price_detail_cubit/market_price_detail_state.dart';

class MockGetAssetTypesUseCase implements GetAssetTypesUseCase {
  ApiResult<List<AssetTypeEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<AssetTypeEntity>>> call() async => result;
}

class MockGetMarketPriceRangeUseCase implements GetMarketPriceRangeUseCase {
  ApiResult<List<MarketPricePointEntity>> result = const Success(
    <MarketPricePointEntity>[],
  );
  GetMarketPriceRangeParams? lastParams;

  @override
  Future<ApiResult<List<MarketPricePointEntity>>> call(
    GetMarketPriceRangeParams params,
  ) async {
    lastParams = params;
    return result;
  }
}

const _usdType = AssetTypeEntity(
  id: 'type-usd',
  code: 'usd',
  name: 'US Dollar',
  isMarketBased: true,
  baseUnit: 'USD',
);

List<MarketPricePointEntity> _points(int count) {
  return [
    for (var i = 0; i < count; i++)
      MarketPricePointEntity(
        date: DateTime(2026, 8, 14).subtract(Duration(days: i)),
        price: Decimal.parse('126'),
      ),
  ];
}

void main() {
  late MockGetAssetTypesUseCase typesUseCase;
  late MockGetMarketPriceRangeUseCase rangeUseCase;

  setUp(() {
    typesUseCase = MockGetAssetTypesUseCase()
      ..result = const Success([_usdType]);
    rangeUseCase = MockGetMarketPriceRangeUseCase()
      ..result = Success(_points(7));
  });

  test('loads type then price range and emits loaded', () async {
    final cubit = MarketPriceDetailCubit(
      assetTypeId: 'type-usd',
      getAssetTypes: typesUseCase,
      getRange: rangeUseCase,
    );
    final states = <MarketPriceDetailState>[];
    final subscription = cubit.stream.listen(states.add);
    await Future<void>.delayed(Duration.zero);

    expect(states.last, isA<MarketPriceDetailLoaded>());
    final loaded = states.last as MarketPriceDetailLoaded;
    expect(loaded.assetType.code, 'usd');
    expect(loaded.selectedRange, MarketPriceRangeOption.oneWeek);
    expect(loaded.points, hasLength(7));
    expect(loaded.daysCovered, 7);
    final to = rangeUseCase.lastParams!.to;
    expect(to, DateTime(2026, 8, 14));
    expect(rangeUseCase.lastParams!.from, to.subtract(const Duration(days: 7)));
    expect(rangeUseCase.lastParams!.assetTypeCode, 'usd');

    await subscription.cancel();
    await cubit.close();
  });

  test(
    'loadRange recomputes from and to and updates the range option',
    () async {
      final cubit = MarketPriceDetailCubit(
        assetTypeId: 'type-usd',
        getAssetTypes: typesUseCase,
        getRange: rangeUseCase,
      );
      final states = <MarketPriceDetailState>[];
      final subscription = cubit.stream.listen(states.add);
      await Future<void>.delayed(Duration.zero);
      rangeUseCase.lastParams = null;

      cubit.loadRange(MarketPriceRangeOption.oneMonth);

      await Future<void>.delayed(Duration.zero);
      final loaded = states.last as MarketPriceDetailLoaded;
      expect(loaded.selectedRange, MarketPriceRangeOption.oneMonth);
      expect(loaded.daysCovered, 7);
      final to = rangeUseCase.lastParams!.to;
      expect(to, DateTime(2026, 8, 14));
      expect(
        rangeUseCase.lastParams!.from,
        to.subtract(const Duration(days: 30)),
      );

      await subscription.cancel();
      await cubit.close();
    },
  );

  test('loadRange works from the error state', () async {
    rangeUseCase.result = const ResultFailure(ServerFailure('down'));
    final cubit = MarketPriceDetailCubit(
      assetTypeId: 'type-usd',
      getAssetTypes: typesUseCase,
      getRange: rangeUseCase,
    );
    final states = <MarketPriceDetailState>[];
    final subscription = cubit.stream.listen(states.add);
    await Future<void>.delayed(Duration.zero);
    expect(states.last, isA<MarketPriceDetailError>());

    rangeUseCase.result = Success(_points(7));
    cubit.loadRange(MarketPriceRangeOption.threeMonths);

    await Future<void>.delayed(Duration.zero);
    expect(states.last, isA<MarketPriceDetailLoaded>());
    expect(
      (states.last as MarketPriceDetailLoaded).selectedRange,
      MarketPriceRangeOption.threeMonths,
    );
    final to = rangeUseCase.lastParams!.to;
    expect(
      rangeUseCase.lastParams!.from,
      to.subtract(const Duration(days: 90)),
    );

    await subscription.cancel();
    await cubit.close();
  });

  test('emits error when asset types cannot be fetched', () async {
    typesUseCase.result = const ResultFailure(CacheFailure('no cache'));

    final cubit = MarketPriceDetailCubit(
      assetTypeId: 'type-usd',
      getAssetTypes: typesUseCase,
      getRange: rangeUseCase,
    );
    final states = <MarketPriceDetailState>[];
    final subscription = cubit.stream.listen(states.add);
    await Future<void>.delayed(Duration.zero);

    expect(states.last, isA<MarketPriceDetailError>());

    await subscription.cancel();
    await cubit.close();
  });
}

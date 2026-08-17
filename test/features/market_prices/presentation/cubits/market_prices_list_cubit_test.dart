import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';
import 'package:qeema/features/market_prices/domain/usecases/get_market_price_summaries_usecase.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_prices_list_cubit/market_prices_list_cubit.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_prices_list_cubit/market_prices_list_state.dart';

class MockGetMarketPriceSummariesUseCase
    implements GetMarketPriceSummariesUseCase {
  ApiResult<List<MarketPriceSummaryEntity>> result = const Success(
    <MarketPriceSummaryEntity>[],
  );
  int callCount = 0;

  @override
  Future<ApiResult<List<MarketPriceSummaryEntity>>> call() async {
    callCount++;
    return result;
  }
}

void main() {
  late MockGetMarketPriceSummariesUseCase useCase;
  late MarketPricesListCubit cubit;

  setUp(() {
    useCase = MockGetMarketPriceSummariesUseCase();
    cubit = MarketPricesListCubit(useCase);
  });

  tearDown(() => cubit.close());

  test('emits loading then success with summaries on load', () async {
    const type = AssetTypeEntity(
      id: 'type-usd',
      code: 'usd',
      name: 'US Dollar',
      isMarketBased: true,
      baseUnit: 'USD',
    );
    useCase.result = Success([
      MarketPriceSummaryEntity(
        assetType: type,
        todayPrice: Decimal.parse('126'),
        todayPriceDate: DateTime(2026, 8, 14),
        fetchedAt: DateTime(2026, 8, 14, 6),
        weeklyChangePercent: Decimal.parse('12.5'),
        sparklinePoints: const [],
      ),
    ]);

    final expected = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<MarketPricesListLoading>(),
        isA<MarketPricesListLoaded>(),
      ]),
    );
    await cubit.load();
    await expected;
    expect(useCase.callCount, 1);
    final state = cubit.state;
    expect(state, isA<MarketPricesListLoaded>());
    expect((state as MarketPricesListLoaded).summaries, hasLength(1));
  });

  test('emits error state on failure', () async {
    useCase.result = const ResultFailure(NetworkFailure('offline'));

    final expected = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<MarketPricesListLoading>(),
        isA<MarketPricesListError>(),
      ]),
    );
    await cubit.load();
    await expected;
    expect(
      (cubit.state as MarketPricesListError).failure,
      isA<NetworkFailure>(),
    );
  });

  test('refresh does not emit loading again', () async {
    useCase.result = const Success(<MarketPriceSummaryEntity>[]);

    final emissions = <MarketPricesListState>[];
    final subscription = cubit.stream.listen(emissions.add);
    await cubit.load();
    await Future<void>.delayed(Duration.zero);
    await cubit.refresh();
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(useCase.callCount, 2);
    final loadingEmissions = emissions
        .whereType<MarketPricesListLoading>()
        .length;
    expect(loadingEmissions, 1);
  });
}

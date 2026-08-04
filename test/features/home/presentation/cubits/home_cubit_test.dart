import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/home/domain/entities/asset_type_summary_entity.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';
import 'package:qeema/features/home/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:qeema/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:qeema/features/home/presentation/cubits/home_cubit/home_state.dart';

class MockGetDashboardSummaryUseCase implements GetDashboardSummaryUseCase {
  ApiResult<DashboardSummaryEntity> result = const ResultFailure(
    CacheFailure(),
  );
  int callCount = 0;

  @override
  Future<ApiResult<DashboardSummaryEntity>> call() async {
    callCount++;
    return result;
  }
}

const _usdType = AssetTypeEntity(
  id: 'type-usd',
  code: 'usd',
  name: 'USD',
  isMarketBased: true,
  baseUnit: 'USD',
);

DashboardSummaryEntity _summary({
  List<AssetTypeSummaryEntity> summaries = const [],
  Decimal? nominalTotal,
}) {
  return DashboardSummaryEntity(
    nominalTotal: nominalTotal ?? Decimal.zero,
    realTotal: nominalTotal ?? Decimal.zero,
    assetTypeSummaries: summaries,
    trend30Days: const [],
  );
}

void main() {
  late MockGetDashboardSummaryUseCase useCase;
  late HomeCubit cubit;

  setUp(() {
    useCase = MockGetDashboardSummaryUseCase();
    cubit = HomeCubit(useCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('HomeCubit', () {
    test('initial state is HomeLoading', () {
      expect(cubit.state, isA<HomeLoading>());
    });

    test('loadDashboard emits HomeLoaded with summary on success', () async {
      final summary = _summary(nominalTotal: Decimal.fromInt(100));
      useCase.result = Success(summary);

      final future = expectLater(
        cubit.stream,
        emitsInOrder([isA<HomeLoading>(), isA<HomeLoaded>()]),
      );
      await cubit.loadDashboard();
      await future;

      final state = cubit.state as HomeLoaded;
      expect(state.summary, same(summary));
      expect(state.bannerDismissed, isFalse);
    });

    test('loadDashboard emits HomeError on failure', () async {
      final future = expectLater(
        cubit.stream,
        emitsInOrder([isA<HomeLoading>(), isA<HomeError>()]),
      );
      await cubit.loadDashboard();
      await future;

      expect((cubit.state as HomeError).failure, isA<CacheFailure>());
    });

    test('refresh triggers the usecase again', () async {
      useCase.result = Success(_summary());

      await cubit.refresh();

      expect(useCase.callCount, 1);
      await cubit.refresh();
      expect(useCase.callCount, 2);
    });

    test('dismissBanner hides the banner without refetching', () async {
      useCase.result = Success(_summary());
      await cubit.loadDashboard();
      final callsAfterLoad = useCase.callCount;

      cubit.dismissBanner();

      expect(useCase.callCount, callsAfterLoad);
      expect((cubit.state as HomeLoaded).bannerDismissed, isTrue);
    });

    test('dismissBanner is a no-op outside HomeLoaded', () async {
      cubit.dismissBanner();

      expect(cubit.state, isA<HomeLoading>());
    });
  });

  group('HomeLoaded.shouldShowBanner', () {
    AssetTypeSummaryEntity summaryWith(
      double dayChange, {
      bool sufficient = true,
    }) {
      return AssetTypeSummaryEntity(
        assetType: _usdType,
        currentValue: Decimal.fromInt(100),
        dayChangePercent: Decimal.parse(dayChange.toStringAsFixed(2)),
        hasSufficientPriceHistory: sufficient,
      );
    }

    test('true when a type moves at least 2% with sufficient history', () {
      final loaded = HomeLoaded(
        summary: _summary(summaries: [summaryWith(2.5)]),
      );
      expect(loaded.shouldShowBanner, isTrue);
    });

    test('false when the move is below the 2% threshold', () {
      final loaded = HomeLoaded(
        summary: _summary(summaries: [summaryWith(1.9)]),
      );
      expect(loaded.shouldShowBanner, isFalse);
    });

    test('false when the move has insufficient price history', () {
      final loaded = HomeLoaded(
        summary: _summary(summaries: [summaryWith(5, sufficient: false)]),
      );
      expect(loaded.shouldShowBanner, isFalse);
    });

    test('false once dismissed', () {
      final loaded = HomeLoaded(
        summary: _summary(summaries: [summaryWith(2.5)]),
      ).copyWith(bannerDismissed: true);
      expect(loaded.shouldShowBanner, isFalse);
    });
  });
}

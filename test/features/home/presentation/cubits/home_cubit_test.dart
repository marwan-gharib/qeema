import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
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

    // Banner dismissal APIs were removed from the cubit/state. Tests
    // relying on that behaviour were therefore removed to match the
    // current implementation (cubit only exposes load/refresh).
  });

  // Banner-related logic moved out of the public state; no unit tests
  // for `shouldShowBanner` exist in this branch.
}

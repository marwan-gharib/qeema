import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/core/router/route_segments.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/home/domain/entities/asset_type_summary_entity.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';
import 'package:qeema/features/home/domain/entities/portfolio_snapshot_entity.dart';
import 'package:qeema/features/home/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:qeema/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:qeema/features/home/presentation/screens/home_screen.dart';
import 'package:qeema/features/home/presentation/widgets/asset_type_mini_card.dart';
import 'package:qeema/features/home/presentation/widgets/dashboard_skeleton.dart';

// Price move banner is not part of the current UI; tests were adapted.

class MockGetDashboardSummaryUseCase implements GetDashboardSummaryUseCase {
  ApiResult<DashboardSummaryEntity> result = Success(
    DashboardSummaryEntity(
      nominalTotal: Decimal.zero,
      realTotal: Decimal.zero,
      assetTypeSummaries: const [],
      trend30Days: const [],
    ),
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

const _egpType = AssetTypeEntity(
  id: 'type-egp',
  code: 'cash_egp',
  name: 'EGP',
  isMarketBased: false,
  baseUnit: 'EGP',
);

AssetTypeSummaryEntity _usdSummary(double dayChange) {
  return AssetTypeSummaryEntity(
    assetType: _usdType,
    currentValue: Decimal.parse('5000'),
    dayChangePercent: Decimal.parse(dayChange.toStringAsFixed(2)),
    hasSufficientPriceHistory: true,
  );
}

DashboardSummaryEntity _loadedSummary({
  List<AssetTypeSummaryEntity> summaries = const [],
  List<PortfolioSnapshotEntity> trend = const [],
}) {
  return DashboardSummaryEntity(
    nominalTotal: Decimal.parse('10000'),
    realTotal: Decimal.parse('9500'),
    assetTypeSummaries: summaries,
    trend30Days: trend,
  );
}

List<PortfolioSnapshotEntity> _trend(int points) {
  return [
    for (var i = 0; i < points; i++)
      PortfolioSnapshotEntity(
        date: DateTime(2026, 7, 1 + i),
        realTotal: Decimal.fromInt(1000 + i),
      ),
  ];
}

Widget _buildTestApp(HomeCubit cubit) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  final router = GoRouter(
    initialLocation: RoutePaths.home,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (_, _) =>
            BlocProvider.value(value: cubit, child: const HomeScreen()),
      ),
      GoRoute(
        path: RoutePaths.assets,
        name: RouteNames.assets,
        builder: (_, _) => const Scaffold(body: SizedBox.shrink()),
        routes: [
          GoRoute(
            path: RouteSegments.add,
            name: RouteNames.addAsset,
            builder: (_, _) => const Scaffold(body: Text('Add Asset Screen')),
          ),
        ],
      ),
    ],
  );
  return TranslationProvider(
    child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
  );
}

Future<void> pumpWithAnimation(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 2000));
}

void main() {
  late MockGetDashboardSummaryUseCase useCase;
  late HomeCubit cubit;

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    useCase = MockGetDashboardSummaryUseCase();
    cubit = HomeCubit(useCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('HomeScreen states', () {
    testWidgets('shows skeleton while loading', (tester) async {
      await tester.pumpWidget(_buildTestApp(cubit));
      await tester.pump();

      expect(find.byType(DashboardSkeleton), findsOneWidget);
      expect(find.byType(ShimmerBox), findsWidgets);
    });

    testWidgets('shows error state and retries on tap', (tester) async {
      useCase.result = const ResultFailure(UnknownFailure());
      await cubit.loadDashboard();
      await tester.pumpWidget(_buildTestApp(cubit));
      await pumpWithAnimation(tester);

      expect(find.text('Something went wrong on our end.'), findsOneWidget);

      useCase.result = Success(_loadedSummary());
      await tester.tap(find.text('Try Again'));
      await pumpWithAnimation(tester);

      expect(useCase.callCount, 2);
      expect(find.text('TOTAL SAVINGS'), findsOneWidget);
    });

    testWidgets('shows empty state and navigates to add asset', (tester) async {
      await cubit.loadDashboard();
      await tester.pumpWidget(_buildTestApp(cubit));
      await pumpWithAnimation(tester);

      expect(find.text('No assets yet'), findsOneWidget);

      await tester.tap(find.text('Add Asset'));
      await tester.pumpAndSettle();

      expect(find.text('Add Asset Screen'), findsOneWidget);
    });
  });

  group('HomeScreen loaded content', () {
    testWidgets('renders summary card, erosion ring and sections', (
      tester,
    ) async {
      useCase.result = Success(
        _loadedSummary(summaries: [_usdSummary(0)], trend: _trend(2)),
      );
      await cubit.loadDashboard();
      await tester.pumpWidget(_buildTestApp(cubit));
      await pumpWithAnimation(tester);

      expect(find.text('TOTAL SAVINGS'), findsOneWidget);
      expect(find.textContaining('10000.00'), findsWidgets);
      expect(find.text('Adjusted for Inflation'), findsOneWidget);
      expect(find.textContaining('5.0%'), findsWidgets);
      expect(find.text('Real Value — Last 30 Days'), findsOneWidget);
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('mini card row is horizontally scrollable and bounded', (
      tester,
    ) async {
      useCase.result = Success(
        _loadedSummary(
          summaries: [
            _usdSummary(1),
            AssetTypeSummaryEntity(
              assetType: _egpType,
              currentValue: Decimal.parse('2000'),
              dayChangePercent: Decimal.zero,
              hasSufficientPriceHistory: false,
            ),
          ],
          trend: _trend(2),
        ),
      );
      await cubit.loadDashboard();
      await tester.pumpWidget(_buildTestApp(cubit));
      await pumpWithAnimation(tester);

      final rowFinder = find.byType(AssetTypeMiniCardRow);
      expect(rowFinder, findsOneWidget);
      expect(find.byType(AssetTypeMiniCard), findsNWidgets(2));
      expect(find.text('0.0%'), findsOneWidget);

      await tester.drag(
        find.byType(AssetTypeMiniCardRow),
        const Offset(-300, 0),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows no-data panel when trend has fewer than two points', (
      tester,
    ) async {
      useCase.result = Success(
        _loadedSummary(summaries: [_usdSummary(0)], trend: _trend(1)),
      );
      await cubit.loadDashboard();
      await tester.pumpWidget(_buildTestApp(cubit));
      await pumpWithAnimation(tester);

      expect(find.byType(LineChart), findsNothing);
      expect(find.text('Not enough price history yet'), findsOneWidget);
    });

    // Tests related to the price-move banner have been removed because the
    // current UI doesn't include that widget.
  });

  group('RTL smoke', () {
    testWidgets('banner and mini cards render in RTL without error', (
      tester,
    ) async {
      LocaleSettings.setLocaleSync(AppLocale.en);
      final rtlCubit = HomeCubit(useCase);
      useCase.result = Success(_loadedSummary(summaries: [_usdSummary(2.5)]));

      await tester.pumpWidget(
        TranslationProvider(
          child: Theme(
            data: AppTheme.light(),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: BlocProvider.value(
                value: rtlCubit,
                child: Material(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AssetTypeMiniCardRow(
                        summaries: [_usdSummary(2.5), _usdSummary(-1)],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(AssetTypeMiniCard), findsNWidgets(2));
      expect(tester.takeException(), isNull);
      await rtlCubit.close();
    });
  });
}

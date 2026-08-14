import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';
import 'package:qeema/features/market_prices/domain/usecases/get_market_price_summaries_usecase.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_prices_list_cubit/market_prices_list_cubit.dart';
import 'package:qeema/features/market_prices/presentation/screens/market_prices_list_screen.dart';
import 'package:qeema/features/market_prices/presentation/widgets/data_source_disclosure.dart';
import 'package:qeema/features/market_prices/presentation/widgets/market_price_card.dart';
import 'package:qeema/features/market_prices/presentation/widgets/market_prices_skeleton.dart';

class MockGetMarketPriceSummariesUseCase
    implements GetMarketPriceSummariesUseCase {
  ApiResult<List<MarketPriceSummaryEntity>> result = const Success(
    <MarketPriceSummaryEntity>[],
  );

  @override
  Future<ApiResult<List<MarketPriceSummaryEntity>>> call() async => result;
}

const _usdType = AssetTypeEntity(
  id: 'type-usd',
  code: 'usd',
  name: 'US Dollar',
  isMarketBased: true,
  baseUnit: 'USD',
);

const _goldType = AssetTypeEntity(
  id: 'type-gold',
  code: 'gold_21',
  name: 'Gold 21K',
  isMarketBased: true,
  baseUnit: 'gram',
);

MarketPriceSummaryEntity _summary(AssetTypeEntity type) {
  return MarketPriceSummaryEntity(
    assetType: type,
    todayPrice: Decimal.parse('6178.89'),
    todayPriceDate: DateTime(2026, 8, 14),
    fetchedAt: DateTime.now().subtract(const Duration(hours: 2)),
    weeklyChangePercent: Decimal.parse('1.5'),
    sparklinePoints: [
      for (var i = 0; i < 7; i++)
        MarketPricePointEntity(
          date: DateTime(2026, 8, 8 + i),
          price: Decimal.parse('120'),
        ),
    ],
  );
}

Widget _screen(MarketPricesListCubit cubit) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: BlocProvider<MarketPricesListCubit>(
        create: (_) => cubit,
        child: const MarketPricesListScreen(),
      ),
    ),
  );
}

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  // ShimmerBox animates indefinitely, so pumpAndSettle never settles; the
  // project pattern is fixed-duration pumps (see home_screen_test.dart).
  Future<void> pumpWithAnimation(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 2000));
  }

  testWidgets('shows skeleton while loading, then cards', (tester) async {
    final useCase = MockGetMarketPriceSummariesUseCase()
      ..result = Success([_summary(_usdType), _summary(_goldType)]);
    final cubit = MarketPricesListCubit(useCase);

    await tester.pumpWidget(_screen(cubit));
    expect(find.byType(MarketPricesSkeleton), findsOneWidget);
    await cubit.load();
    await pumpWithAnimation(tester);
    expect(find.byType(MarketPricesSkeleton), findsNothing);
    expect(find.byType(MarketPriceCard), findsNWidgets(2));
    expect(find.text('US Dollar'), findsOneWidget);
    expect(find.text('Gold 21K'), findsOneWidget);
    expect(find.byType(DataSourceDisclosure), findsOneWidget);

    await cubit.close();
  });

  testWidgets('shows empty state when no summaries', (tester) async {
    final cubit = MarketPricesListCubit(MockGetMarketPriceSummariesUseCase());
    await cubit.load();

    await tester.pumpWidget(_screen(cubit));
    await pumpWithAnimation(tester);

    expect(find.byType(MarketPriceCard), findsNothing);
    expect(find.text(t.marketPrices.emptyTitle), findsOneWidget);
    expect(find.byType(DataSourceDisclosure), findsOneWidget);

    await cubit.close();
  });
}

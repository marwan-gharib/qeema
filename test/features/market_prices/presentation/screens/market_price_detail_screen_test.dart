import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/widgets/app_empty_state.dart';
import 'package:qeema/core/widgets/app_error_state.dart';
import 'package:qeema/core/widgets/app_loader.dart';
import 'package:qeema/core/widgets/market_price_chart.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';
import 'package:qeema/features/market_prices/domain/params/get_market_price_range_params.dart';
import 'package:qeema/features/market_prices/domain/usecases/get_market_price_range_usecase.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_price_detail_cubit/market_price_detail_cubit.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_price_detail_cubit/market_price_detail_state.dart';
import 'package:qeema/features/market_prices/presentation/screens/market_price_detail_screen.dart';
import 'package:qeema/features/market_prices/presentation/widgets/data_source_disclosure.dart';
import 'package:qeema/features/market_prices/presentation/widgets/range_selector_chips.dart';

class MockGetAssetTypesUseCase implements GetAssetTypesUseCase {
  ApiResult<List<AssetTypeEntity>> result = const Success([]);

  /// When set, the call blocks until the gate is completed — keeps the
  /// loading state on screen for the loading assertion.
  Completer<ApiResult<List<AssetTypeEntity>>>? gate;

  @override
  Future<ApiResult<List<AssetTypeEntity>>> call() async =>
      gate?.future ?? result;
}

class MockGetMarketPriceRangeUseCase implements GetMarketPriceRangeUseCase {
  ApiResult<List<MarketPricePointEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<MarketPricePointEntity>>> call(
    GetMarketPriceRangeParams params,
  ) async => result;
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
        date: DateTime(2026, 8, 8 + i),
        price: Decimal.parse('${120 + i}'),
      ),
  ];
}

Widget _harness(MarketPriceDetailCubit cubit) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: BlocProvider<MarketPriceDetailCubit>.value(
        value: cubit,
        child: const MarketPriceDetailScreen(),
      ),
    ),
  );
}

void main() {
  late MockGetAssetTypesUseCase typesUseCase;
  late MockGetMarketPriceRangeUseCase rangeUseCase;

  setUp(() async {
    await initializeDateFormatting('en');
    LocaleSettings.setLocaleSync(AppLocale.en);
    typesUseCase = MockGetAssetTypesUseCase();
    rangeUseCase = MockGetMarketPriceRangeUseCase();
  });

  // AppLoader shimmers indefinitely, so pumpAndSettle never settles; the
  // project pattern is fixed-duration pumps (see market_prices_list_screen_test).
  Future<void> pumpThrough(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 2000));
  }

  testWidgets('shows the loader first, then the chart with range chips', (
    tester,
  ) async {
    typesUseCase.gate = Completer<ApiResult<List<AssetTypeEntity>>>();
    rangeUseCase.result = Success(_points(7));
    final cubit = MarketPriceDetailCubit(
      assetTypeId: 'type-usd',
      getAssetTypes: typesUseCase,
      getRange: rangeUseCase,
    );

    await tester.pumpWidget(_harness(cubit));
    expect(find.byType(AppLoader), findsOneWidget);

    typesUseCase.gate!.complete(const Success([_usdType]));
    await pumpThrough(tester);
    expect(find.byType(AppLoader), findsNothing);
    expect(find.byType(MarketPriceChart), findsOneWidget);
    expect(find.byType(RangeSelectorChips), findsOneWidget);
    expect(find.byType(DataSourceDisclosure), findsOneWidget);
    expect(find.text(t.assets.list.tabUsd), findsOneWidget);

    await cubit.close();
  });

  testWidgets('shows the empty state when fewer than two points exist', (
    tester,
  ) async {
    typesUseCase.result = const Success([_usdType]);
    rangeUseCase.result = Success(_points(1));
    final cubit = MarketPriceDetailCubit(
      assetTypeId: 'type-usd',
      getAssetTypes: typesUseCase,
      getRange: rangeUseCase,
    );

    await tester.pumpWidget(_harness(cubit));
    await pumpThrough(tester);

    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.byType(MarketPriceChart), findsNothing);

    await cubit.close();
  });

  testWidgets('shows the error state with retry when the load fails', (
    tester,
  ) async {
    typesUseCase.result = const ResultFailure(UnknownFailure());
    final cubit = MarketPriceDetailCubit(
      assetTypeId: 'type-usd',
      getAssetTypes: typesUseCase,
      getRange: rangeUseCase,
    );

    await tester.pumpWidget(_harness(cubit));
    await pumpThrough(tester);

    expect(find.byType(AppErrorState), findsOneWidget);
    expect(find.byType(MarketPriceChart), findsNothing);

    await cubit.close();
  });

  testWidgets('tapping a range chip reloads with the selected range', (
    tester,
  ) async {
    typesUseCase.result = const Success([_usdType]);
    rangeUseCase.result = Success(_points(7));
    final cubit = MarketPriceDetailCubit(
      assetTypeId: 'type-usd',
      getAssetTypes: typesUseCase,
      getRange: rangeUseCase,
    );

    await tester.pumpWidget(_harness(cubit));
    await pumpThrough(tester);

    await tester.tap(
      find.widgetWithText(ChoiceChip, t.marketPrices.range.oneMonth),
    );
    await pumpThrough(tester);

    expect(cubit.lastRange, MarketPriceRangeOption.oneMonth);

    await cubit.close();
  });
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/domain/asset_type.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/widgets/app_empty_state.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/refresh_assets_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_cubit.dart';
import 'package:qeema/features/assets/presentation/screens/assets_list_screen.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_list_item.dart';
import 'package:qeema/features/assets/presentation/widgets/assets_error_state.dart';
import 'package:qeema/features/assets/presentation/widgets/assets_loading_skeleton.dart';

class MockGetAssetsUseCase implements GetAssetsUseCase {
  ApiResult<List<AssetEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<AssetEntity>>> call() async => result;

  @override
  AssetsRepository get repository => throw UnimplementedError();
}

class MockRefreshAssetsUseCase implements RefreshAssetsUseCase {
  ApiResult<List<AssetEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<AssetEntity>>> call() async => result;

  @override
  AssetsRepository get repository => throw UnimplementedError();
}

final _usdAsset = AssetEntity(
  id: 'usd-1',
  assetType: AssetType.usdCash,
  amount: 10,
  priceAtEntry: 48,
  entryDate: DateTime(2026, 5, 1),
);

final _egpAsset = AssetEntity(
  id: 'egp-1',
  assetType: AssetType.egpCash,
  amount: 500,
  priceAtEntry: 1,
  entryDate: DateTime(2026, 7, 1),
);

Widget _harness(AssetsListCubit cubit) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: BlocProvider<AssetsListCubit>.value(
        value: cubit,
        child: const AssetsListScreen(),
      ),
    ),
  );
}

void main() {
  late MockGetAssetsUseCase getAssets;
  late MockRefreshAssetsUseCase refreshAssets;
  late AssetsListCubit cubit;

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    getAssets = MockGetAssetsUseCase();
    refreshAssets = MockRefreshAssetsUseCase();
    cubit = AssetsListCubit(getAssets, refreshAssets);
  });

  // Shimmer + entrance animations never settle; fixed-duration pumps are the
  // project pattern (see market_prices_list_screen_test.dart).
  Future<void> pumpThrough(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 2000));
  }

  testWidgets('shows the skeleton while loading', (tester) async {
    await tester.pumpWidget(_harness(cubit));

    expect(find.byType(AssetsLoadingSkeleton), findsOneWidget);

    await cubit.loadAssets();
    await pumpThrough(tester);
    expect(find.byType(AssetsLoadingSkeleton), findsNothing);

    await cubit.close();
  });

  testWidgets('shows the assets with the filter bar when loaded', (
    tester,
  ) async {
    getAssets.result = Success([_usdAsset, _egpAsset]);
    await tester.pumpWidget(_harness(cubit));
    await cubit.loadAssets();
    await pumpThrough(tester);

    expect(find.byType(AssetListItem), findsNWidgets(2));

    await cubit.close();
  });

  testWidgets('shows the error state when the load fails', (tester) async {
    getAssets.result = const ResultFailure(UnknownFailure());
    await tester.pumpWidget(_harness(cubit));
    await cubit.loadAssets();
    await pumpThrough(tester);

    expect(find.byType(AssetsErrorState), findsOneWidget);
    expect(find.byType(AssetListItem), findsNothing);

    await cubit.close();
  });

  testWidgets(
    'shows the empty state with an add action when there are no assets',
    (tester) async {
      await tester.pumpWidget(_harness(cubit));
      await cubit.loadAssets();
      await pumpThrough(tester);

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.text(t.assets.list.addFirst), findsOneWidget);

      await cubit.close();
    },
  );
}

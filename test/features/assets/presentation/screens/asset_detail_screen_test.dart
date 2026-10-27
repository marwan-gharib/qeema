import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/domain/asset_type.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/widgets/app_empty_state.dart';
import 'package:qeema/core/widgets/app_error_state.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_history_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_market_price_history_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/soft_delete_asset_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/asset_detail_cubit/asset_detail_cubit.dart';
import 'package:qeema/features/assets/presentation/screens/asset_detail_screen.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_detail_content.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_detail_skeleton.dart';

class MockGetAssetsUseCase implements GetAssetsUseCase {
  Completer<ApiResult<List<AssetEntity>>>? gate;
  ApiResult<List<AssetEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<AssetEntity>>> call() async => gate?.future ?? result;

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
  ApiResult<List<MarketPriceEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<MarketPriceEntity>>> call(String assetTypeCode) async =>
      result;
}

class MockSoftDeleteAssetUseCase implements SoftDeleteAssetUseCase {
  ApiResult<void> result = const Success(null);

  @override
  Future<ApiResult<void>> call(String assetId) async => result;
}

final _usdAsset = AssetEntity(
  id: 'usd-1',
  assetType: AssetType.usdCash,
  amount: 10,
  priceAtEntry: 48,
  entryDate: DateTime(2026, 5, 1),
);

Widget _harness(AssetDetailCubit cubit) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: BlocProvider<AssetDetailCubit>.value(
        value: cubit,
        child: const AssetDetailScreen(),
      ),
    ),
  );
}

void main() {
  late MockGetAssetsUseCase getAssets;
  late MockGetAssetHistoryUseCase getHistory;
  late MockGetMarketPriceHistoryUseCase getPriceHistory;
  late MockSoftDeleteAssetUseCase softDelete;

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    getAssets = MockGetAssetsUseCase();
    getHistory = MockGetAssetHistoryUseCase();
    getPriceHistory = MockGetMarketPriceHistoryUseCase();
    softDelete = MockSoftDeleteAssetUseCase();
  });

  // Shimmer + entrance animations never settle; fixed-duration pumps are the
  // project pattern (see market_prices_list_screen_test.dart).
  Future<void> pumpThrough(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 2000));
  }

  AssetDetailCubit buildCubit() {
    return AssetDetailCubit(
      assetId: 'usd-1',
      getAssets: getAssets,
      getHistory: getHistory,
      getPriceHistory: getPriceHistory,
      softDelete: softDelete,
    );
  }

  testWidgets('shows the skeleton while loading, then the detail content', (
    tester,
  ) async {
    getAssets.gate = Completer<ApiResult<List<AssetEntity>>>();
    getHistory.result = const Success([]);
    getPriceHistory.result = const Success([]);
    final cubit = buildCubit();

    await tester.pumpWidget(_harness(cubit));
    expect(find.byType(AssetDetailSkeleton), findsOneWidget);

    getAssets.gate!.complete(Success([_usdAsset]));
    await pumpThrough(tester);
    expect(find.byType(AssetDetailSkeleton), findsNothing);
    expect(find.byType(AssetDetailContent), findsOneWidget);
    expect(find.text(t.assets.list.tabUsd), findsWidgets);

    await cubit.close();
  });

  testWidgets('shows the not-found empty state when the asset id is missing', (
    tester,
  ) async {
    getAssets.result = const Success([]);
    final cubit = buildCubit();

    await tester.pumpWidget(_harness(cubit));
    await pumpThrough(tester);

    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.byType(AssetDetailContent), findsNothing);

    await cubit.close();
  });

  testWidgets('shows the error state with retry when the load fails', (
    tester,
  ) async {
    getAssets.result = const ResultFailure(UnknownFailure());
    final cubit = buildCubit();

    await tester.pumpWidget(_harness(cubit));
    await pumpThrough(tester);

    expect(find.byType(AppErrorState), findsOneWidget);
    expect(find.byType(AssetDetailContent), findsNothing);

    await cubit.close();
  });
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/domain/asset_type.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_error_state.dart';
import 'package:qeema/core/widgets/app_loader.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/update_asset_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/edit_asset_cubit/edit_asset_cubit.dart';
import 'package:qeema/features/assets/presentation/screens/edit_asset_screen.dart';
import 'package:qeema/features/assets/presentation/widgets/dynamic_asset_fields.dart';
import 'package:qeema/features/assets/presentation/widgets/edit_asset_header.dart';

class MockGetAssetsUseCase implements GetAssetsUseCase {
  Completer<ApiResult<List<AssetEntity>>>? gate;
  ApiResult<List<AssetEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<AssetEntity>>> call() async => gate?.future ?? result;

  @override
  AssetsRepository get repository => throw UnimplementedError();
}

class MockUpdateAssetUseCase implements UpdateAssetUseCase {
  ApiResult<AssetEntity> result = Success(
    AssetEntity(
      id: 'usd-1',
      assetType: AssetType.usdCash,
      amount: 100,
      priceAtEntry: 48,
      entryDate: DateTime(2026, 5, 1),
    ),
  );

  @override
  Future<ApiResult<AssetEntity>> call(UpdateAssetParams params) async => result;
}

final _usdAsset = AssetEntity(
  id: 'usd-1',
  assetType: AssetType.usdCash,
  amount: 100,
  priceAtEntry: 48,
  entryDate: DateTime(2026, 5, 1),
);

Widget _harness(EditAssetCubit cubit) {
  // The screen returns the edit result with GoRouter's `context.pop`, so the
  // harness must pump a router-backed MaterialApp (see the delete-dialog test).
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => BlocProvider<EditAssetCubit>.value(
          value: cubit,
          child: const EditAssetScreen(),
        ),
      ),
    ],
  );
  return TranslationProvider(
    child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
  );
}

void main() {
  late MockGetAssetsUseCase getAssets;
  late MockUpdateAssetUseCase updateAsset;

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    getAssets = MockGetAssetsUseCase();
    updateAsset = MockUpdateAssetUseCase();
  });

  // Entrance animations never settle; fixed-duration pumps are the project
  // pattern (see market_prices_list_screen_test.dart).
  Future<void> pumpThrough(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 2000));
  }

  EditAssetCubit buildCubit() {
    return EditAssetCubit(
      assetId: 'usd-1',
      getAssets: getAssets,
      updateAsset: updateAsset,
    );
  }

  testWidgets('shows the loader first, then the edit form', (tester) async {
    getAssets.gate = Completer<ApiResult<List<AssetEntity>>>();
    final cubit = buildCubit();

    await tester.pumpWidget(_harness(cubit));
    expect(find.byType(AppLoader), findsOneWidget);

    getAssets.gate!.complete(Success([_usdAsset]));
    await pumpThrough(tester);
    expect(find.byType(AppLoader), findsNothing);
    expect(find.byType(EditAssetHeader), findsOneWidget);
    expect(find.byType(DynamicAssetFields), findsOneWidget);
    expect(find.byType(AppButton), findsOneWidget);

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
    expect(find.byType(EditAssetHeader), findsNothing);

    await cubit.close();
  });

  testWidgets(
    'keeps the submit button disabled until the user changes the form',
    (tester) async {
      getAssets.result = Success([_usdAsset]);
      final cubit = buildCubit();

      await tester.pumpWidget(_harness(cubit));
      await pumpThrough(tester);

      final submit = tester.widget<AppButton>(find.byType(AppButton));
      expect(submit.onPressed, isNull);

      await cubit.close();
    },
  );
}

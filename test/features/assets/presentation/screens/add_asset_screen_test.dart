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
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/usecases/add_asset_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/add_asset_cubit/add_asset_cubit.dart';
import 'package:qeema/features/assets/presentation/screens/add_asset_screen.dart';
import 'package:qeema/features/assets/presentation/widgets/add_asset_skeleton.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_type_picker.dart';
import 'package:qeema/features/assets/presentation/widgets/dynamic_asset_fields.dart';

class MockGetAssetTypesUseCase implements GetAssetTypesUseCase {
  ApiResult<List<AssetTypeEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<AssetTypeEntity>>> call() async => result;
}

class MockAddAssetUseCase implements AddAssetUseCase {
  ApiResult<AssetEntity> result = Success(
    AssetEntity(
      id: 'new-asset',
      assetType: AssetType.usdCash,
      amount: 10,
      priceAtEntry: 48,
      entryDate: DateTime(2026, 8, 1),
    ),
  );

  @override
  Future<ApiResult<AssetEntity>> call(AddAssetParams params) async => result;
}

const _usdType = AssetTypeEntity(
  id: 'type-usd',
  code: 'usd',
  name: 'US Dollar',
  isMarketBased: true,
  baseUnit: 'USD',
);

const _egpType = AssetTypeEntity(
  id: 'type-egp',
  code: 'cash_egp',
  name: 'Cash (EGP)',
  isMarketBased: false,
  baseUnit: 'EGP',
);

Widget _harness(AddAssetCubit cubit) {
  // The screen dismisses with GoRouter's `context.pop` on success, so the
  // harness must pump a router-backed MaterialApp (see the delete-dialog test).
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => BlocProvider<AddAssetCubit>.value(
          value: cubit,
          child: const AddAssetScreen(),
        ),
      ),
    ],
  );
  return TranslationProvider(
    child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
  );
}

void main() {
  late MockGetAssetTypesUseCase typesUseCase;
  late MockAddAssetUseCase addAssetUseCase;
  late AddAssetCubit cubit;

  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    typesUseCase = MockGetAssetTypesUseCase();
    addAssetUseCase = MockAddAssetUseCase();
    cubit = AddAssetCubit(typesUseCase, addAssetUseCase);
  });

  // Shimmer + AnimatedSwitcher never settle; fixed-duration pumps are the
  // project pattern (see market_prices_list_screen_test.dart).
  Future<void> pumpThrough(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 2000));
  }

  testWidgets('shows the skeleton while the types load', (tester) async {
    await tester.pumpWidget(_harness(cubit));

    expect(find.byType(AddAssetSkeleton), findsOneWidget);

    await cubit.loadAssetTypes();
    await pumpThrough(tester);
    expect(find.byType(AddAssetSkeleton), findsNothing);

    await cubit.close();
  });

  testWidgets('shows the form with the USD type preselected', (tester) async {
    typesUseCase.result = const Success([_egpType, _usdType]);
    await tester.pumpWidget(_harness(cubit));
    await cubit.loadAssetTypes();
    await pumpThrough(tester);

    expect(find.byType(AssetTypePicker), findsOneWidget);
    expect(find.byType(DynamicAssetFields), findsOneWidget);
    expect(find.widgetWithText(AppButton, t.assets.add.submit), findsOneWidget);
    expect(cubit.state.selectedType, _usdType);

    await cubit.close();
  });

  testWidgets('leaves the form rendered when the types load fails', (
    tester,
  ) async {
    typesUseCase.result = const ResultFailure(UnknownFailure());
    await tester.pumpWidget(_harness(cubit));
    await cubit.loadAssetTypes();
    await pumpThrough(tester);

    expect(find.byType(AddAssetSkeleton), findsNothing);
    expect(find.byType(AppButton), findsOneWidget);

    await cubit.close();
  });
}

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/app_root.dart';
import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/local/cache/cache_service.dart';
import 'package:qeema/core/navigation/app_shell.dart';
import 'package:qeema/core/navigation/bottom_nav_item.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/router/app_router.dart';
import 'package:qeema/core/router/route_guards.dart';
import 'package:qeema/core/services/app_lock_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_cubit.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';
import 'package:qeema/features/home/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:qeema/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';
import 'package:qeema/features/market_prices/domain/usecases/get_market_price_summaries_usecase.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_prices_list_cubit/market_prices_list_cubit.dart';
import 'package:qeema/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:qeema/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:qeema/features/onboarding/domain/usecases/get_onboarding_seen_usecase.dart';
import 'package:qeema/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:qeema/features/settings/presentation/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/home/data/repositories/mocks/mock_home_dependencies.dart';
import '../helpers/mocks.dart';
import '../helpers/settings_mocks.dart';

class FakeSupabaseClientProvider extends SupabaseClientProvider {
  @override
  SupabaseClient get client => fakeClient;

  static final SupabaseClient fakeClient = SupabaseClient(
    'https://qeema-test.supabase.co',
    'anon-test-key',
  );
}

class MockGetMarketPriceSummariesUseCase
    implements GetMarketPriceSummariesUseCase {
  ApiResult<List<MarketPriceSummaryEntity>> result = const Success([]);

  @override
  Future<ApiResult<List<MarketPriceSummaryEntity>>> call() async => result;
}

class MockGetDashboardSummaryUseCase implements GetDashboardSummaryUseCase {
  ApiResult<DashboardSummaryEntity> result = const ResultFailure(
    CacheFailure(),
  );

  @override
  Future<ApiResult<DashboardSummaryEntity>> call() async => result;
}

String _fakeJwt() {
  final header = base64UrlEncode(utf8.encode('{"alg":"HS256","typ":"JWT"}'));
  final exp =
      DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch ~/
      1000;
  final payload = base64UrlEncode(
    utf8.encode('{"sub":"test-user","role":"authenticated","exp":$exp}'),
  );
  return '$header.$payload.fake-signature';
}

String _fakeSessionJson() {
  return jsonEncode({
    'access_token': _fakeJwt(),
    'refresh_token': 'fake-refresh-token',
    'expires_in': 3600,
    'token_type': 'bearer',
    'user': {
      'id': 'test-user',
      'aud': 'authenticated',
      'role': 'authenticated',
      'email': 'test@qeema.test',
      'app_metadata': {'provider': 'email'},
      'user_metadata': Map<String, dynamic>.from({}),
      'identities': [
        {
          'id': 'test-user',
          'user_id': 'test-user',
          'identity_data': {'sub': 'test-user'},
          'provider': 'email',
          'last_sign_in_at': null,
          'created_at': null,
          'updated_at': null,
        },
      ],
    },
  });
}

void main() {
  const packageInfoChannel = MethodChannel(
    'dev.fluttercommunity.plus/package_info',
  );

  late MockCacheService cacheService;
  final supabaseProvider = FakeSupabaseClientProvider();
  var homeCubitCreations = 0;
  var assetsCubitCreations = 0;
  var marketCubitCreations = 0;
  var deleteCubitCreations = 0;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(packageInfoChannel, (call) async {
          return {
            'appName': 'Qeema',
            'packageName': 'com.qeema.app',
            'version': '1.0.0',
            'buildNumber': '1',
            'buildSignature': '',
          };
        });
    LocaleSettings.setLocaleSync(AppLocale.en);
    QeemaApp.debugMaterialAppBuilds = 0;
    homeCubitCreations = 0;
    assetsCubitCreations = 0;
    marketCubitCreations = 0;
    deleteCubitCreations = 0;
    cacheService = MockCacheService();

    final onboardingRepo = MockOnboardingRepository()..hasSeenResult = true;
    final onboardingSeen = MockGetOnboardingSeenUseCase()
      ..result = const Success(true);
    getIt
      ..registerLazySingleton<SupabaseClientProvider>(() => supabaseProvider)
      ..registerLazySingleton<AppLockService>(
        () => AppLockService(MockSecureStorageService()),
      )
      ..registerLazySingleton<BiometricAuthService>(
        () => BiometricAuthService(MockLocalAuthentication()),
      )
      ..registerFactory<LockCubit>(
        () => LockCubit(getIt<BiometricAuthService>()),
      )
      ..registerLazySingleton<CacheService>(() => cacheService)
      ..registerLazySingleton<LocaleCubit>(
        () => LocaleCubit(getIt<CacheService>()),
      )
      ..registerLazySingleton<ThemeCubit>(
        () => ThemeCubit(getIt<CacheService>()),
      )
      ..registerLazySingleton<OnboardingRepository>(() => onboardingRepo)
      ..registerLazySingleton<GetOnboardingSeenUseCase>(() => onboardingSeen)
      ..registerLazySingleton<CompleteOnboardingUseCase>(
        () => MockCompleteOnboardingUseCase(),
      )
      ..registerFactory<OnboardingCubit>(
        () => OnboardingCubit(getIt<CompleteOnboardingUseCase>()),
      )
      ..registerLazySingleton<RouteGuards>(
        () => RouteGuards(
          getIt<SupabaseClientProvider>(),
          getIt<GetOnboardingSeenUseCase>(),
        ),
      )
      ..registerFactory<HomeCubit>(() {
        homeCubitCreations++;
        return HomeCubit(MockGetDashboardSummaryUseCase());
      })
      ..registerFactory<AssetsListCubit>(() {
        assetsCubitCreations++;
        // A const Success([]) is unmodifiable and AssetsListLoaded
        // .visibleAssets sorts it in place — the list must stay growable.
        // ignore: prefer_const_constructors
        return AssetsListCubit(MockGetAssetsUseCase(result: Success([])));
      })
      ..registerFactory<MarketPricesListCubit>(() {
        marketCubitCreations++;
        return MarketPricesListCubit(MockGetMarketPriceSummariesUseCase());
      })
      ..registerFactory<DeleteAccountCubit>(() {
        deleteCubitCreations++;
        return DeleteAccountCubit(MockDeleteAccountUseCase());
      });

    await supabaseProvider.client.auth.recoverSession(_fakeSessionJson());
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(packageInfoChannel, null);
    getIt.reset();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<LocaleCubit>()),
          BlocProvider(create: (_) => getIt<ThemeCubit>()),
        ],
        child: TranslationProvider(child: const AppRoot()),
      ),
    );
  }

  /// Freeze detector: pumpAndSettle throws if frames keep being scheduled
  /// (an infinite rebuild loop renders the app unresponsive).
  Future<void> settle(WidgetTester tester) async {
    try {
      await tester.pumpAndSettle(
        const Duration(milliseconds: 50),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 10),
      );
    } on FlutterError catch (_) {
      // ignore: avoid_print
      print(
        'SETTLE TIMEOUT: transientCallbacks='
        '${tester.binding.transientCallbackCount} '
        'hasScheduledFrame=${tester.binding.hasScheduledFrame}',
      );
      for (final w
          in tester.allWidgets.whereType<CircularProgressIndicator>()) {
        // ignore: avoid_print
        print('CircularProgressIndicator found: $w');
      }
      // ignore: avoid_print
      print('--- widget tree around the spinner ---');
      // ignore: avoid_print
      debugDumpApp();
      rethrow;
    }
  }

  testWidgets('cold start, tab taps, and theme/locale changes keep the app '
      'responsive and preserve the navigation stack', (tester) async {
    await pumpApp(tester);
    await settle(tester);

    expect(AppRouter.router, same(AppRouter.router));
    expect(
      getIt<LocaleCubit>(),
      same(getIt<LocaleCubit>()),
      reason: 'LocaleCubit must be a DI singleton',
    );
    expect(
      getIt<ThemeCubit>(),
      same(getIt<ThemeCubit>()),
      reason: 'ThemeCubit must be a DI singleton',
    );

    // Land on the shell (Home tab).
    AppRouter.router.go('/home');
    await settle(tester);
    expect(find.byType(AppShell), findsOneWidget);
    // Tap through every tab.
    await tester.tap(find.text('Assets'));
    await settle(tester);
    await tester.tap(find.text('Market Prices'));
    await settle(tester);
    await tester.tap(find.text('Settings'));
    await settle(tester);
    expect(find.byType(SettingsScreen), findsOneWidget);

    // Theme + locale changes while on Settings.
    await getIt<ThemeCubit>().setThemeMode(ThemeMode.dark);
    await settle(tester);
    await getIt<ThemeCubit>().setThemeMode(ThemeMode.light);
    await settle(tester);
    // Ar translations use a deferred library: its loadLibrary() future only
    // completes on the real event loop, so drive it through runAsync.
    await tester.runAsync(() => getIt<LocaleCubit>().setLocale(AppLocale.ar));
    await settle(tester);
    await tester.runAsync(() => getIt<LocaleCubit>().setLocale(AppLocale.en));
    await settle(tester);

    // Round-trip away and back; the shell branches must survive.
    await tester.tap(find.text('Home'));
    await settle(tester);
    await tester.tap(find.text('Settings'));
    await settle(tester);
    expect(find.byType(SettingsScreen), findsOneWidget);

    expect(
      homeCubitCreations,
      1,
      reason: 'Home branch was torn down and recreated',
    );
    expect(
      assetsCubitCreations,
      1,
      reason: 'Assets branch was torn down and recreated',
    );
    expect(
      marketCubitCreations,
      1,
      reason: 'Market Prices branch was torn down and recreated',
    );
    expect(
      deleteCubitCreations,
      1,
      reason: 'Settings branch was torn down and recreated',
    );
    expect(
      QeemaApp.debugMaterialAppBuilds,
      lessThan(20),
      reason: 'MaterialApp.router rebuilt far too often â€” rebuild loop',
    );
  });

  testWidgets('cold start with a persisted Arabic locale renders and stays '
      'responsive', (tester) async {
    await cacheService.set(key: AppConstants.appLocaleKey, value: 'ar');
    LocaleSettings.setLocaleSync(AppLocale.en);

    await pumpApp(tester);
    // Let the unawaited ar restore (deferred library load) complete on the
    // real event loop before settling.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await settle(tester);

    // The persisted ar locale must be restored and the tree must build
    // (regression for "No MaterialLocalizations found" freezing the app).
    expect(getIt<LocaleCubit>().state.locale, AppLocale.ar);
    expect(find.byType(AppShell), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Tapping any button must not throw or stall (labels are Arabic here,
    // so tap the nav item widget rather than translated text).
    await tester.tap(find.byType(BottomNavItem).at(1));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(SettingsScreen), findsNothing);
  });
}

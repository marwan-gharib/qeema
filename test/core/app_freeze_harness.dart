import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/app_root.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/local/cache/cache_service.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/router/route_guards.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_lifecycle_observer.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_cubit.dart';
import 'package:qeema/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_prices_list_cubit/market_prices_list_cubit.dart';
import 'package:qeema/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:qeema/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:qeema/features/onboarding/domain/usecases/get_onboarding_seen_usecase.dart';
import 'package:qeema/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/profile_header_cubit/profile_header_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/app_lock_mocks.dart';
import '../helpers/mocks.dart';
import '../helpers/settings_mocks.dart';
import 'app_freeze_mocks.dart';

/// Shared rig for the app-freeze regressions: a fully mocked DI container, a
/// fake Supabase session, the mocked package-info channel, and the production
/// app pump (lifecycle observer included). [dispose] drains the container and
/// the channel handler.
class AppFreezeHarness {
  AppFreezeHarness._(this.cacheService);

  static const packageInfoChannel = MethodChannel(
    'dev.fluttercommunity.plus/package_info',
  );

  static Future<AppFreezeHarness> create() async {
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

    final harness = AppFreezeHarness._(MockCacheService());
    harness._registerDependencies();
    await harness.supabaseProvider.client.auth.recoverSession(
      fakeSessionJson(),
    );
    return harness;
  }

  final MockCacheService cacheService;
  final supabaseProvider = FakeSupabaseClientProvider();
  var homeCubitCreations = 0;
  var assetsCubitCreations = 0;
  var marketCubitCreations = 0;
  var deleteCubitCreations = 0;

  int get materialAppBuilds => QeemaApp.debugMaterialAppBuilds;

  void _registerDependencies() {
    final onboardingRepo = MockOnboardingRepository()..hasSeenResult = true;
    final onboardingSeen = MockGetOnboardingSeenUseCase()
      ..result = const Success(true);
    getIt
      ..registerLazySingleton<SupabaseClientProvider>(() => supabaseProvider)
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
      ..registerFactory<HomeCubit>(() {
        homeCubitCreations++;
        return HomeCubit(MockGetDashboardSummaryUseCase());
      })
      ..registerFactory<AssetsListCubit>(() {
        assetsCubitCreations++;
        return AssetsListCubit(
          MockGetAssetsUseCase(),
          MockRefreshAssetsUseCase(),
        );
      })
      ..registerFactory<MarketPricesListCubit>(() {
        marketCubitCreations++;
        return MarketPricesListCubit(MockGetMarketPriceSummariesUseCase());
      })
      ..registerFactory<DeleteAccountCubit>(() {
        deleteCubitCreations++;
        return DeleteAccountCubit(MockDeleteAccountUseCase());
      })
      ..registerFactory<LogoutCubit>(
        () => LogoutCubit(
          MockLogoutUseCase(),
          MockIsCurrentUserAnonymousUseCase(isAnonymous: false),
        ),
      )
      ..registerFactory<ProfileHeaderCubit>(
        () => ProfileHeaderCubit(
          MockWatchAuthUserUseCase()..result = const Stream.empty(),
        ),
      )
      ..registerLazySingleton<AppLockCubit>(
        () => AppLockCubit(
          MockGetAppLockEnabledUseCase(),
          MockCheckDeviceLockAvailableUseCase(),
          MockAuthenticateDeviceUseCase(),
          MockSetRecentsPreviewHiddenUseCase(),
        ),
      )
      ..registerFactory<AppLockSettingsCubit>(
        () => AppLockSettingsCubit(
          MockGetAppLockEnabledUseCase(),
          MockSetAppLockEnabledUseCase(),
          MockCheckDeviceLockAvailableUseCase(),
          MockAuthenticateDeviceUseCase(),
          getIt<AppLockCubit>(),
        ),
      )
      ..registerLazySingleton<RouteGuards>(
        () => RouteGuards(
          getIt<SupabaseClientProvider>(),
          getIt<GetOnboardingSeenUseCase>(),
          FakeAppLockGate(),
        ),
      );
  }

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<LocaleCubit>()),
          BlocProvider(create: (_) => getIt<ThemeCubit>()),
          BlocProvider(create: (_) => getIt<AppLockCubit>()),
        ],
        // main.dart wraps the app in the lifecycle observer; without it the
        // lock gate never leaves AppLockInitial and the overlay blanks the
        // router, so mirror the production wiring here.
        child: AppLockLifecycleObserver(
          child: TranslationProvider(child: const AppRoot()),
        ),
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

  void dispose() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(packageInfoChannel, null);
    getIt.reset();
  }
}

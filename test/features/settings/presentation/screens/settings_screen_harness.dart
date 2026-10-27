import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/profile_header_cubit/profile_header_cubit.dart';
import 'package:qeema/features/settings/presentation/screens/settings_screen.dart';

import '../../../../helpers/app_lock_mocks.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/recording_locale_cubit.dart';
import '../../../../helpers/settings_mocks.dart';

/// Shared widget-test rig for the settings screen: the mock cubits and
/// usecases, the router-backed MaterialApp with stub welcome/onboarding
/// routes, and the mocked package-info channel. [dispose] drains everything
/// [create] built.
class SettingsScreenHarness {
  SettingsScreenHarness._({
    required this.cacheService,
    required this.localeCubit,
    required this.themeCubit,
    required this.deleteUseCase,
    required this.deleteCubit,
    required this.logoutUseCase,
    required this.logoutCubit,
    required this.profileHeaderCubit,
    required this.getAppLockEnabled,
    required this.setAppLockEnabled,
    required this.checkDeviceLockAvailable,
    required this.authenticateDevice,
    required this.appLockCubit,
    required this.appLockSettingsCubit,
  });

  static const packageInfoChannel = MethodChannel(
    'dev.fluttercommunity.plus/package_info',
  );

  /// Creates the rig and completes the app-lock settings load, as a pumped
  /// screen expects.
  static Future<SettingsScreenHarness> create() async {
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
    final cacheService = MockCacheService();
    final localeCubit = RecordingLocaleCubit(cacheService);
    final themeCubit = ThemeCubit(cacheService);
    final deleteUseCase = MockDeleteAccountUseCase();
    final deleteCubit = DeleteAccountCubit(deleteUseCase);
    final logoutUseCase = MockLogoutUseCase();
    final logoutCubit = LogoutCubit(
      logoutUseCase,
      MockIsCurrentUserAnonymousUseCase(isAnonymous: false),
    );
    final profileHeaderCubit = ProfileHeaderCubit(
      MockWatchAuthUserUseCase()
        ..result = Stream.value(
          const Success(
            AuthUserEntity(id: 'user-1', email: '', isAnonymous: true),
          ),
        ),
    );
    final getAppLockEnabled = MockGetAppLockEnabledUseCase();
    final setAppLockEnabled = MockSetAppLockEnabledUseCase();
    final checkDeviceLockAvailable = MockCheckDeviceLockAvailableUseCase();
    final authenticateDevice = MockAuthenticateDeviceUseCase();
    final appLockCubit = SpyAppLockCubit(
      getAppLockEnabled,
      checkDeviceLockAvailable,
      authenticateDevice,
      MockSetRecentsPreviewHiddenUseCase(),
    );
    final appLockSettingsCubit = AppLockSettingsCubit(
      getAppLockEnabled,
      setAppLockEnabled,
      checkDeviceLockAvailable,
      authenticateDevice,
      appLockCubit,
    );
    await appLockSettingsCubit.load();

    return SettingsScreenHarness._(
      cacheService: cacheService,
      localeCubit: localeCubit,
      themeCubit: themeCubit,
      deleteUseCase: deleteUseCase,
      deleteCubit: deleteCubit,
      logoutUseCase: logoutUseCase,
      logoutCubit: logoutCubit,
      profileHeaderCubit: profileHeaderCubit,
      getAppLockEnabled: getAppLockEnabled,
      setAppLockEnabled: setAppLockEnabled,
      checkDeviceLockAvailable: checkDeviceLockAvailable,
      authenticateDevice: authenticateDevice,
      appLockCubit: appLockCubit,
      appLockSettingsCubit: appLockSettingsCubit,
    );
  }

  final MockCacheService cacheService;
  final RecordingLocaleCubit localeCubit;
  final ThemeCubit themeCubit;
  final MockDeleteAccountUseCase deleteUseCase;
  final DeleteAccountCubit deleteCubit;
  final MockLogoutUseCase logoutUseCase;
  final LogoutCubit logoutCubit;
  final ProfileHeaderCubit profileHeaderCubit;
  final MockGetAppLockEnabledUseCase getAppLockEnabled;
  final MockSetAppLockEnabledUseCase setAppLockEnabled;
  final MockCheckDeviceLockAvailableUseCase checkDeviceLockAvailable;
  final MockAuthenticateDeviceUseCase authenticateDevice;
  final SpyAppLockCubit appLockCubit;
  final AppLockSettingsCubit appLockSettingsCubit;

  Widget build() {
    final router = GoRouter(
      initialLocation: RoutePaths.settings,
      routes: [
        GoRoute(
          path: RoutePaths.settings,
          name: RouteNames.settings,
          builder: (_, _) => const SettingsScreen(),
        ),
        GoRoute(
          path: RoutePaths.welcome,
          name: RouteNames.welcome,
          builder: (_, _) => const Scaffold(body: Text('Welcome Stub')),
        ),
        GoRoute(
          path: RoutePaths.onboarding,
          name: RouteNames.onboarding,
          builder: (_, _) => const Scaffold(body: Text('Onboarding Stub')),
        ),
      ],
    );
    return TranslationProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocaleCubit>.value(value: localeCubit),
          BlocProvider<ThemeCubit>.value(value: themeCubit),
          BlocProvider<DeleteAccountCubit>.value(value: deleteCubit),
          BlocProvider<LogoutCubit>.value(value: logoutCubit),
          BlocProvider<ProfileHeaderCubit>.value(value: profileHeaderCubit),
          BlocProvider<AppLockCubit>.value(value: appLockCubit),
          BlocProvider<AppLockSettingsCubit>.value(value: appLockSettingsCubit),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
  }

  /// Entrance animations never settle; fixed-duration pumps are the project
  /// pattern (see market_prices_list_screen_test.dart).
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 1000));
  }

  void dispose() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(packageInfoChannel, null);
    localeCubit.close();
    themeCubit.close();
    deleteCubit.close();
    logoutCubit.close();
    profileHeaderCubit.close();
    appLockCubit.close();
    appLockSettingsCubit.close();
    getIt.reset();
  }
}

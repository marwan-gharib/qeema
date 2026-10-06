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
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_text_field.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/profile_header_cubit/profile_header_cubit.dart';
import 'package:qeema/features/settings/presentation/screens/settings_screen.dart';
import 'package:qeema/features/settings/presentation/widgets/language_selector_sheet.dart';
import 'package:qeema/features/settings/presentation/widgets/profile_header_card.dart';
import 'package:qeema/features/settings/presentation/widgets/theme_selector_sheet.dart';

import '../../../../helpers/app_lock_mocks.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/recording_locale_cubit.dart';
import '../../../../helpers/settings_mocks.dart';

void main() {
  late MockCacheService cacheService;
  late LocaleCubit localeCubit;
  late ThemeCubit themeCubit;
  late MockDeleteAccountUseCase deleteUseCase;
  late DeleteAccountCubit deleteCubit;
  late MockLogoutUseCase logoutUseCase;
  late LogoutCubit logoutCubit;
  late ProfileHeaderCubit profileHeaderCubit;
  late MockGetAppLockEnabledUseCase getAppLockEnabled;
  late MockSetAppLockEnabledUseCase setAppLockEnabled;
  late MockCheckDeviceLockAvailableUseCase checkDeviceLockAvailable;
  late MockAuthenticateDeviceUseCase authenticateDevice;
  late SpyAppLockCubit appLockCubit;
  late AppLockSettingsCubit appLockSettingsCubit;

  const packageInfoChannel = MethodChannel(
    'dev.fluttercommunity.plus/package_info',
  );

  setUp(() async {
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
    cacheService = MockCacheService();
    localeCubit = RecordingLocaleCubit(cacheService);
    themeCubit = ThemeCubit(cacheService);
    deleteUseCase = MockDeleteAccountUseCase();
    deleteCubit = DeleteAccountCubit(deleteUseCase);
    logoutUseCase = MockLogoutUseCase();
    logoutCubit = LogoutCubit(
      logoutUseCase,
      MockAccountRepository(isAnonymous: false),
    );
    profileHeaderCubit = ProfileHeaderCubit(
      MockWatchAuthUserUseCase()
        ..result = Stream.value(
          const Success(
            AuthUserEntity(id: 'user-1', email: '', isAnonymous: true),
          ),
        ),
    );
    getAppLockEnabled = MockGetAppLockEnabledUseCase();
    setAppLockEnabled = MockSetAppLockEnabledUseCase();
    checkDeviceLockAvailable = MockCheckDeviceLockAvailableUseCase();
    authenticateDevice = MockAuthenticateDeviceUseCase();
    appLockCubit = SpyAppLockCubit(
      getAppLockEnabled,
      checkDeviceLockAvailable,
      authenticateDevice,
      MockSetRecentsPreviewHiddenUseCase(),
    );
    appLockSettingsCubit = AppLockSettingsCubit(
      getAppLockEnabled,
      setAppLockEnabled,
      checkDeviceLockAvailable,
      authenticateDevice,
      appLockCubit,
    );
    await appLockSettingsCubit.load();
  });

  tearDown(() {
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
  });

  Widget harness() {
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

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 1000));
  }

  testWidgets('renders four sections including security', (tester) async {
    await tester.pumpWidget(harness());
    await settle(tester);

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('PREFERENCES'), findsOneWidget);
    expect(find.text('SECURITY'), findsOneWidget);
    expect(find.text('ABOUT'), findsOneWidget);
    expect(find.text('DANGER ZONE'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('App Lock'), findsOneWidget);
    expect(find.text('App Version'), findsOneWidget);
    expect(find.text('Data & Methodology'), findsOneWidget);
    expect(find.text('Delete Account'), findsOneWidget);
  });

  testWidgets('turning app lock off authenticates first, then persists and '
      'refreshes the gate', (tester) async {
    await tester.pumpWidget(harness());
    await settle(tester);

    final toggle = find.byType(Switch);
    expect(tester.widget<Switch>(toggle).value, isTrue);

    await tester.ensureVisible(toggle);
    await tester.pump();
    await tester.tap(toggle);
    await tester.pumpAndSettle();

    expect(authenticateDevice.reasons, hasLength(1));
    expect(setAppLockEnabled.calls, [false]);
    expect(appLockCubit.refreshCalls, 1);
    expect(tester.widget<Switch>(toggle).value, isFalse);
  });

  testWidgets('turning app lock off keeps the switch on when the user '
      'cancels the prompt', (tester) async {
    authenticateDevice.result = const Success(AppLockStatus.failed);
    await tester.pumpWidget(harness());
    await settle(tester);

    final toggle = find.byType(Switch);
    await tester.ensureVisible(toggle);
    await tester.pump();
    await tester.tap(toggle);
    await tester.pumpAndSettle();

    expect(setAppLockEnabled.calls, isEmpty);
    expect(tester.widget<Switch>(toggle).value, isTrue);
  });

  testWidgets('disables the switch with an explanation when the device has '
      'no lock', (tester) async {
    checkDeviceLockAvailable.result = const Success(false);
    await appLockSettingsCubit.load();
    await tester.pumpWidget(harness());
    await settle(tester);

    expect(
      find.text(
        'Set a screen lock (PIN, pattern, or password) in system settings '
        'to use App Lock',
      ),
      findsOneWidget,
    );
    expect(tester.widget<Switch>(find.byType(Switch)).onChanged, isNull);

    await tester.ensureVisible(find.byType(Switch));
    await tester.pump();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(authenticateDevice.reasons, isEmpty);
    expect(setAppLockEnabled.calls, isEmpty);
  });

  testWidgets('turning app lock on persists without authentication', (
    tester,
  ) async {
    setAppLockEnabled.calls.clear();
    authenticateDevice.reasons.clear();
    getAppLockEnabled.result = const Success(false);
    await appLockSettingsCubit.load();
    await tester.pumpWidget(harness());
    await settle(tester);
    final toggle = find.byType(Switch);
    expect(tester.widget<Switch>(toggle).value, isFalse);

    await tester.ensureVisible(toggle);
    await tester.pump();
    await tester.tap(toggle);
    await tester.pumpAndSettle();

    expect(authenticateDevice.reasons, isEmpty);
    expect(setAppLockEnabled.calls, [true]);
    expect(tester.widget<Switch>(toggle).value, isTrue);
  });

  testWidgets('shows the profile header above the first section', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await settle(tester);

    expect(find.byType(ProfileHeaderCard), findsOneWidget);
    expect(find.text('Guest'), findsOneWidget);
    expect(find.text('Signed in as guest'), findsOneWidget);

    final headerTop = tester.getTopLeft(find.byType(ProfileHeaderCard)).dy;
    final sectionTop = tester.getTopLeft(find.text('PREFERENCES')).dy;
    expect(headerTop, lessThan(sectionTop));
  });

  testWidgets('changing the language updates the preferences tile', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await settle(tester);

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    expect(find.byType(LanguageSelectorSheet), findsOneWidget);
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    expect(localeCubit.state.locale, AppLocale.ar);
    expect(find.text('العربية'), findsOneWidget);
  });

  testWidgets('changing the theme updates the preferences tile', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await settle(tester);

    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();

    expect(find.byType(ThemeSelectorSheet), findsOneWidget);
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(themeCubit.state.mode, ThemeMode.dark);
    expect(find.text('Dark'), findsOneWidget);
  });

  testWidgets('shows the methodology sheet', (tester) async {
    await tester.pumpWidget(harness());
    await settle(tester);

    await tester.tap(find.text('Data & Methodology'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Prices are based on international spot rates'),
      findsOneWidget,
    );
  });

  testWidgets('deleting the account navigates to welcome on success', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await settle(tester);

    await tester.ensureVisible(find.text('Delete Account'));
    await tester.pump();
    await tester.tap(find.text('Delete Account'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(AppTextField), 'DELETE');
    await tester.pump();
    await tester.tap(find.widgetWithText(AppButton, 'Delete Forever'));
    await tester.pumpAndSettle();

    expect(deleteUseCase.calls, 1);
    expect(find.text('Welcome Stub'), findsOneWidget);
  });

  testWidgets('logging out as Google user navigates to welcome', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await settle(tester);

    await tester.ensureVisible(find.text('Log Out'));
    await tester.pump();
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();

    expect(find.text('Log Out?'), findsOneWidget);
    await tester.tap(find.widgetWithText(AppButton, 'Log Out'));
    await tester.pumpAndSettle();

    expect(logoutUseCase.calls, 1);
    expect(find.text('Welcome Stub'), findsOneWidget);
  });
}

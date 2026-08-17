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
import 'package:qeema/core/services/app_lock_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_text_field.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:qeema/features/settings/presentation/screens/settings_screen.dart';
import 'package:qeema/features/settings/presentation/widgets/language_selector_sheet.dart';
import 'package:qeema/features/settings/presentation/widgets/theme_selector_sheet.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/recording_locale_cubit.dart';
import '../../../../helpers/settings_mocks.dart';

void main() {
  late MockCacheService cacheService;
  late LocaleCubit localeCubit;
  late ThemeCubit themeCubit;
  late MockDeleteAccountUseCase deleteUseCase;
  late DeleteAccountCubit deleteCubit;

  const packageInfoChannel = MethodChannel(
    'dev.fluttercommunity.plus/package_info',
  );

  setUp(() {
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

    getIt
      ..registerLazySingleton<AppLockService>(
        () => AppLockService(MockSecureStorageService()),
      )
      ..registerLazySingleton<BiometricAuthService>(
        () => BiometricAuthService(MockLocalAuthentication()),
      )
      ..registerFactory<LockCubit>(
        () => LockCubit(getIt<BiometricAuthService>()),
      );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(packageInfoChannel, null);
    localeCubit.close();
    themeCubit.close();
    deleteCubit.close();
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

  testWidgets('renders all four sections', (tester) async {
    await tester.pumpWidget(harness());
    await settle(tester);

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('SECURITY'), findsOneWidget);
    expect(find.text('PREFERENCES'), findsOneWidget);
    expect(find.text('ABOUT'), findsOneWidget);
    expect(find.text('DANGER ZONE'), findsOneWidget);
    expect(find.text('Require device unlock to open Qeema'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('App Version'), findsOneWidget);
    expect(find.text('Data & Methodology'), findsOneWidget);
    expect(find.text('Delete Account'), findsOneWidget);
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

  testWidgets('deleting the account navigates to onboarding on success', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await settle(tester);

    await tester.tap(find.text('Delete Account'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(AppTextField), 'DELETE');
    await tester.pump();
    await tester.tap(find.widgetWithText(AppButton, 'Delete Forever'));
    await tester.pumpAndSettle();

    expect(deleteUseCase.calls, 1);
    expect(find.text('Onboarding Stub'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/navigation/app_shell.dart';
import 'package:qeema/core/navigation/bottom_nav_item.dart';
import 'package:qeema/core/router/app_router.dart';
import 'package:qeema/features/settings/presentation/screens/settings_screen.dart';

import 'app_freeze_harness.dart';

/// Regressions for the "app freezes / rebuilds forever" reports: after a cold
/// start the shell must settle, every tab must be tappable, theme and locale
/// changes must not loop, and shell branches must survive a round trip.
void main() {
  late AppFreezeHarness harness;

  setUp(() async {
    harness = await AppFreezeHarness.create();
  });

  tearDown(() {
    harness.dispose();
  });

  testWidgets('cold start, tab taps, and theme/locale changes keep the app '
      'responsive and preserve the navigation stack', (tester) async {
    await harness.pumpApp(tester);
    await harness.settle(tester);

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
    await harness.settle(tester);
    expect(find.byType(AppShell), findsOneWidget);
    // Tap through every tab.
    await tester.tap(find.text('Assets'));
    await harness.settle(tester);
    await tester.tap(find.text('Market Prices'));
    await harness.settle(tester);
    await tester.tap(find.text('Settings'));
    await harness.settle(tester);
    expect(find.byType(SettingsScreen), findsOneWidget);

    // Theme + locale changes while on Settings.
    await getIt<ThemeCubit>().setThemeMode(ThemeMode.dark);
    await harness.settle(tester);
    await getIt<ThemeCubit>().setThemeMode(ThemeMode.light);
    await harness.settle(tester);
    // Ar translations use a deferred library: its loadLibrary() future only
    // completes on the real event loop, so drive it through runAsync.
    await tester.runAsync(() => getIt<LocaleCubit>().setLocale(AppLocale.ar));
    await harness.settle(tester);
    await tester.runAsync(() => getIt<LocaleCubit>().setLocale(AppLocale.en));
    await harness.settle(tester);

    // Round-trip away and back; the shell branches must survive.
    await tester.tap(find.text('Home'));
    await harness.settle(tester);
    await tester.tap(find.text('Settings'));
    await harness.settle(tester);
    expect(find.byType(SettingsScreen), findsOneWidget);

    expect(
      harness.homeCubitCreations,
      1,
      reason: 'Home branch was torn down and recreated',
    );
    expect(
      harness.assetsCubitCreations,
      1,
      reason: 'Assets branch was torn down and recreated',
    );
    expect(
      harness.marketCubitCreations,
      1,
      reason: 'Market Prices branch was torn down and recreated',
    );
    expect(
      harness.deleteCubitCreations,
      1,
      reason: 'Settings branch was torn down and recreated',
    );
    expect(
      harness.materialAppBuilds,
      lessThan(20),
      reason: 'MaterialApp.router rebuilt far too often — rebuild loop',
    );
  });

  testWidgets('cold start with a persisted Arabic locale renders and stays '
      'responsive', (tester) async {
    await harness.cacheService.set(key: AppConstants.appLocaleKey, value: 'ar');
    LocaleSettings.setLocaleSync(AppLocale.en);

    await harness.pumpApp(tester);
    // Let the unawaited ar restore (deferred library load) complete on the
    // real event loop before settling.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await harness.settle(tester);

    // The persisted ar locale must be restored and the tree must build
    // (regression for "No MaterialLocalizations found" freezing the app).
    expect(getIt<LocaleCubit>().state.locale, AppLocale.ar);
    expect(find.byType(AppShell), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Tapping any button must not throw or stall (labels are Arabic here,
    // so tap the nav item widget rather than translated text).
    await tester.tap(find.byType(BottomNavItem).at(1));
    await harness.settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(SettingsScreen), findsNothing);
  });
}

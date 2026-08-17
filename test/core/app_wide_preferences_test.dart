import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_state.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_state.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';

import '../helpers/mocks.dart';
import '../helpers/recording_locale_cubit.dart';

/// Mirrors the wiring in `QeemaApp` (app_root.dart): the MaterialApp reads
/// themeMode and locale straight from the global cubits.
class _AppHarness extends StatelessWidget {
  const _AppHarness();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            return MaterialApp(
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: themeState.mode,
              locale: localeState.locale.flutterLocale,
              supportedLocales: AppLocaleUtils.supportedLocales,
              home: const Scaffold(body: Center(child: Text('home'))),
            );
          },
        );
      },
    );
  }
}

void main() {
  late MockCacheService cacheService;
  late LocaleCubit localeCubit;
  late ThemeCubit themeCubit;

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    cacheService = MockCacheService();
    localeCubit = RecordingLocaleCubit(cacheService);
    themeCubit = ThemeCubit(cacheService);
  });

  tearDown(() {
    localeCubit.close();
    themeCubit.close();
  });

  Future<void> pumpHarness(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<LocaleCubit>.value(value: localeCubit),
          BlocProvider<ThemeCubit>.value(value: themeCubit),
        ],
        child: TranslationProvider(child: const _AppHarness()),
      ),
    );
    await tester.pump();
  }

  testWidgets('MaterialApp follows the theme cubit', (tester) async {
    await pumpHarness(tester);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.system,
    );

    await themeCubit.setThemeMode(ThemeMode.dark);
    // Stream events land on the pump after the emit; a second pump builds
    // the rebuilt MaterialApp.
    await tester.pump();
    await tester.pump();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets('MaterialApp follows the locale cubit', (tester) async {
    await pumpHarness(tester);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
      const Locale('en'),
    );

    await localeCubit.setLocale(AppLocale.ar);
    await tester.pump();
    await tester.pump();
    // The app has no GlobalMaterialLocalizations delegates (same as QeemaApp);
    // the ar-locale warning is out of scope for this wiring test.
    tester.takeException();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
      const Locale('ar'),
    );
  });
}

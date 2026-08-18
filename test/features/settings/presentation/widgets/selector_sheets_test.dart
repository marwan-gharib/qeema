import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/settings/presentation/widgets/language_selector_sheet.dart';
import 'package:qeema/features/settings/presentation/widgets/theme_selector_sheet.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/recording_locale_cubit.dart';

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

  Widget harness() {
    return TranslationProvider(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocaleCubit>.value(value: localeCubit),
          BlocProvider<ThemeCubit>.value(value: themeCubit),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => LanguageSelectorSheet.show(
                        context,
                        localeCubit.state.locale,
                      ),
                      child: const Text('open language'),
                    ),
                    ElevatedButton(
                      onPressed: () => ThemeSelectorSheet.show(
                        context,
                        themeCubit.state.mode,
                      ),
                      child: const Text('open theme'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('language sheet lists both languages with the current marked', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await tester.tap(find.text('open language'));
    await tester.pumpAndSettle();

    expect(find.text('Choose Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('العربية'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('selecting a language updates the locale cubit and closes', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await tester.tap(find.text('open language'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    expect(localeCubit.state.locale, AppLocale.ar);
    expect(find.text('Choose Language'), findsNothing);
  });

  testWidgets('theme sheet lists all modes with the current marked', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await tester.tap(find.text('open theme'));
    await tester.pumpAndSettle();

    expect(find.text('Choose Theme'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('selecting a theme updates the theme cubit and closes', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await tester.tap(find.text('open theme'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(themeCubit.state.mode, ThemeMode.dark);
    expect(find.text('Choose Theme'), findsNothing);
  });
}

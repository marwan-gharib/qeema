import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/features/settings/presentation/widgets/language_selector_sheet.dart';
import 'package:qeema/features/settings/presentation/widgets/profile_header_card.dart';
import 'package:qeema/features/settings/presentation/widgets/theme_selector_sheet.dart';

import 'settings_screen_harness.dart';

void main() {
  late SettingsScreenHarness harness;

  setUp(() async {
    harness = await SettingsScreenHarness.create();
  });

  tearDown(() {
    harness.dispose();
  });

  testWidgets('renders four sections including security', (tester) async {
    await tester.pumpWidget(harness.build());
    await harness.settle(tester);

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

  testWidgets('shows the profile header above the first section', (
    tester,
  ) async {
    await tester.pumpWidget(harness.build());
    await harness.settle(tester);

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
    await tester.pumpWidget(harness.build());
    await harness.settle(tester);

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    expect(find.byType(LanguageSelectorSheet), findsOneWidget);
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();

    expect(harness.localeCubit.state.locale, AppLocale.ar);
    expect(find.text('العربية'), findsOneWidget);
  });

  testWidgets('changing the theme updates the preferences tile', (
    tester,
  ) async {
    await tester.pumpWidget(harness.build());
    await harness.settle(tester);

    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();

    expect(find.byType(ThemeSelectorSheet), findsOneWidget);
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(harness.themeCubit.state.mode, ThemeMode.dark);
    expect(find.text('Dark'), findsOneWidget);
  });

  testWidgets('shows the methodology sheet', (tester) async {
    await tester.pumpWidget(harness.build());
    await harness.settle(tester);

    await tester.tap(find.text('Data & Methodology'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Prices are based on international spot rates'),
      findsOneWidget,
    );
  });
}

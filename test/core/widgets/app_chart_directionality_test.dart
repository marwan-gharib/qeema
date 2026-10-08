import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/constants/chart_constants.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/widgets/app_chart_directionality.dart';

const _siblingKey = Key('wrapper-sibling');

Widget _harness(AppLocale locale, {required String semanticsLabel}) {
  return TranslationProvider(
    child: MaterialApp(
      locale: locale.flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('sibling', key: _siblingKey),
            AppChartDirectionality(
              semanticsLabel: semanticsLabel,
              child: const SizedBox(width: 10, height: 10),
            ),
          ],
        ),
      ),
    ),
  );
}

TextDirection _chartDirection(WidgetTester tester) => tester
    .widget<Directionality>(
      find.descendant(
        of: find.byType(AppChartDirectionality),
        matching: find.byType(Directionality),
      ),
    )
    .textDirection;

/// The Arabic table lives in a deferred slang library, so switching locales
/// has to await the load; `setLocaleSync` throws `_DeferredNotLoadedError`
/// the first time it runs in a test process.
Future<void> _useLocale(WidgetTester tester, AppLocale locale) =>
    tester.runAsync(() => LocaleSettings.setLocale(locale));

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  tearDown(() {
    ChartConstants.alwaysChartsLtr = true;
  });

  test('the chart direction policy is on', () {
    expect(ChartConstants.alwaysChartsLtr, isTrue);
  });

  for (final locale in [AppLocale.en, AppLocale.ar]) {
    final localeName = locale == AppLocale.ar ? 'ar' : 'en';

    testWidgets('pins only the chart to LTR in $localeName', (tester) async {
      await _useLocale(tester, locale);
      await tester.pumpWidget(_harness(locale, semanticsLabel: 'summary'));
      await tester.pump();

      expect(_chartDirection(tester), TextDirection.ltr);
      expect(
        Directionality.of(tester.element(find.byKey(_siblingKey))),
        locale == AppLocale.ar ? TextDirection.rtl : TextDirection.ltr,
      );
    });
  }

  testWidgets('exposes one summary that follows the locale, not the chart', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    try {
      await _useLocale(tester, AppLocale.ar);
      final label = t.charts.semantics.recentPrices;
      await tester.pumpWidget(_harness(AppLocale.ar, semanticsLabel: label));
      await tester.pump();

      expect(label, 'الأسعار الأخيرة');
      expect(find.bySemanticsLabel(label), findsOneWidget);

      final semantics = tester.widget<Semantics>(
        find.descendant(
          of: find.byType(AppChartDirectionality),
          matching: find.byType(Semantics),
        ),
      );
      expect(semantics.properties.label, label);
      expect(semantics.properties.textDirection, TextDirection.rtl);
      expect(_chartDirection(tester), TextDirection.ltr);
    } finally {
      handle.dispose();
    }
  });

  testWidgets('hands the chart back to the locale when the policy is off', (
    tester,
  ) async {
    ChartConstants.alwaysChartsLtr = false;

    await _useLocale(tester, AppLocale.ar);
    await tester.pumpWidget(_harness(AppLocale.ar, semanticsLabel: 'summary'));
    await tester.pump();

    expect(_chartDirection(tester), TextDirection.rtl);
  });
}

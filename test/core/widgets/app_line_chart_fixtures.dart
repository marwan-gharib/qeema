import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;
import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/widgets/app_chart_directionality.dart';
import 'package:qeema/core/widgets/app_line_chart.dart';

/// Shared rig for the [AppLineChart] widget tests (FILE-1 split).

const chartSiblingKey = Key('chart-sibling');

List<AppChartPoint> chartPoints(int count, {double baseValue = 80000}) {
  return [
    for (var i = 0; i < count; i++)
      (
        date: DateTime(2026, 7, 1 + i),
        value: Decimal.fromInt((baseValue + i).toInt()),
      ),
  ];
}

Widget chartHarness(AppLineChart chart) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: chart),
    ),
  );
}

/// Same chart with a sibling outside it, so a test can prove the chart is the
/// only subtree pinned to LTR.
Widget directionalChartHarness(AppLineChart chart, AppLocale locale) {
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
            const Text('sibling', key: chartSiblingKey),
            chart,
          ],
        ),
      ),
    ),
  );
}

AppLineChart homeStyleChart() {
  return AppLineChart(
    semanticsTitle: t.charts.semantics.realValue,
    points: chartPoints(45),
    lineColor: Colors.teal,
    height: 250,
  );
}

LineChart lineChartOf(WidgetTester tester) {
  return tester.widget<LineChart>(find.byType(LineChart));
}

/// The Arabic table lives in a deferred slang library, so switching locales
/// has to await the load; `setLocaleSync` throws `_DeferredNotLoadedError`
/// the first time it runs in a test process.
Future<void> useLocale(WidgetTester tester, AppLocale locale) =>
    tester.runAsync(() => LocaleSettings.setLocale(locale));

TextDirection chartDirection(WidgetTester tester) {
  return tester
      .widget<Directionality>(
        find.descendant(
          of: find.byType(AppChartDirectionality),
          matching: find.byType(Directionality),
        ),
      )
      .textDirection;
}

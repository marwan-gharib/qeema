import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;
import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/helpers/date_formatter.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/widgets/app_chart_directionality.dart';
import 'package:qeema/core/widgets/app_line_chart.dart';

const _siblingKey = Key('chart-sibling');

List<AppChartPoint> _points(int count, {double baseValue = 80000}) {
  return [
    for (var i = 0; i < count; i++)
      (
        date: DateTime(2026, 7, 1 + i),
        value: Decimal.fromInt((baseValue + i).toInt()),
      ),
  ];
}

Widget _chart(AppLineChart chart) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: chart),
    ),
  );
}

/// Same chart with a sibling outside it, so a test can prove the chart is the
/// only subtree pinned to LTR.
Widget _directionalChart(AppLineChart chart, AppLocale locale) {
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
            chart,
          ],
        ),
      ),
    ),
  );
}

AppLineChart _homeStyleChart() {
  return AppLineChart(
    semanticsTitle: t.charts.semantics.realValue,
    points: _points(45),
    lineColor: Colors.teal,
    height: 250,
  );
}

LineChart _lineChart(WidgetTester tester) {
  return tester.widget<LineChart>(find.byType(LineChart));
}

/// The Arabic table lives in a deferred slang library, so switching locales
/// has to await the load; `setLocaleSync` throws `_DeferredNotLoadedError`
/// the first time it runs in a test process.
Future<void> _useLocale(WidgetTester tester, AppLocale locale) =>
    tester.runAsync(() => LocaleSettings.setLocale(locale));

TextDirection _chartDirection(WidgetTester tester) {
  return tester
      .widget<Directionality>(
        find.descendant(
          of: find.byType(AppChartDirectionality),
          matching: find.byType(Directionality),
        ),
      )
      .textDirection;
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('ar');
  });

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  group('home-style chart (defaults)', () {
    testWidgets('renders a sized chart with all 45 spots', (tester) async {
      await tester.pumpWidget(
        _chart(
          AppLineChart(
            semanticsTitle: t.charts.semantics.realValue,
            points: _points(45),
            lineColor: Colors.teal,
            height: 250,
          ),
        ),
      );
      await tester.pump();

      final chart = _lineChart(tester);
      expect(chart.data.lineBarsData.single.spots.length, 45);
      expect(find.byType(SizedBox).first, isNotNull);

      final sizedBox = tester.widget<SizedBox>(
        find.byWidgetPredicate(
          (w) => w is SizedBox && w.height == 250 && w.width == null,
        ),
      );
      expect(sizedBox, isNotNull);
    });

    testWidgets('bounds span the point index range', (tester) async {
      await tester.pumpWidget(
        _chart(
          AppLineChart(
            semanticsTitle: t.charts.semantics.realValue,
            points: _points(45),
            lineColor: Colors.teal,
            height: 250,
          ),
        ),
      );
      await tester.pump();

      final data = _lineChart(tester).data;
      expect(data.minX, 0);
      expect(data.maxX, 44);
    });

    testWidgets('grid interval is y-range divided by 10', (tester) async {
      await tester.pumpWidget(
        _chart(
          AppLineChart(
            semanticsTitle: t.charts.semantics.realValue,
            points: _points(45),
            lineColor: Colors.teal,
            height: 250,
          ),
        ),
      );
      await tester.pump();

      final grid = _lineChart(tester).data.gridData;
      expect(grid.show, isTrue);
      expect(grid.horizontalInterval, 4.4);
    });

    testWidgets('renders sparse bottom date labels', (tester) async {
      await tester.pumpWidget(
        _chart(
          AppLineChart(
            semanticsTitle: t.charts.semantics.realValue,
            points: _points(45),
            lineColor: Colors.teal,
            height: 250,
          ),
        ),
      );
      await tester.pump();

      for (final date in ['Jul 1', 'Jul 10', 'Jul 19', 'Jul 28', 'Aug 6']) {
        expect(find.text(date), findsOneWidget);
      }
    });

    testWidgets('tooltip is enabled by default', (tester) async {
      await tester.pumpWidget(
        _chart(
          AppLineChart(
            semanticsTitle: t.charts.semantics.realValue,
            points: _points(45),
            lineColor: Colors.teal,
            height: 250,
          ),
        ),
      );
      await tester.pump();

      expect(_lineChart(tester).data.lineTouchData.enabled, isTrue);
    });
  });

  group('assets-style chart (denser labels)', () {
    testWidgets('uses feature label density knobs', (tester) async {
      await tester.pumpWidget(
        _chart(
          AppLineChart(
            semanticsTitle: t.charts.semantics.realValue,
            points: _points(45),
            lineColor: Colors.teal,
            gridIntervalDivisor: 6,
            leftTitleIntervalDivisor: 3,
            bottomLabelCount: 4,
          ),
        ),
      );
      await tester.pump();

      final data = _lineChart(tester).data;
      expect(data.gridData.horizontalInterval, 44 / 6);
      expect(
        (data.titlesData.leftTitles.sideTitles.interval as double),
        44 / 3,
      );
      expect(data.titlesData.bottomTitles.sideTitles.interval, 12);
    });
  });

  group('sparkline-style chart', () {
    testWidgets('hides axis labels, grid, and tooltip', (tester) async {
      await tester.pumpWidget(
        _chart(
          AppLineChart(
            semanticsTitle: t.charts.semantics.realValue,
            points: _points(10),
            lineColor: Colors.teal,
            showAxisLabels: false,
            showTooltip: false,
            barWidth: 1.6,
          ),
        ),
      );
      await tester.pump();

      final data = _lineChart(tester).data;
      expect(data.gridData.show, isFalse);
      expect(data.titlesData.show, isFalse);
      expect(data.lineTouchData.enabled, isFalse);
      expect(data.lineBarsData.single.barWidth, 1.6);
    });
  });

  group('locale independence', () {
    const surfaces = <Size>[Size(375, 812), Size(320, 568)];

    for (final locale in [AppLocale.en, AppLocale.ar]) {
      final localeName = locale == AppLocale.ar ? 'ar' : 'en';
      for (final surface in surfaces) {
        testWidgets('chart is LTR in $localeName at $surface', (tester) async {
          tester.view.physicalSize = surface;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          await _useLocale(tester, locale);
          await tester.pumpWidget(_directionalChart(_homeStyleChart(), locale));
          await tester.pump();

          expect(_chartDirection(tester), TextDirection.ltr);
          expect(
            Directionality.of(tester.element(find.byKey(_siblingKey))),
            locale == AppLocale.ar ? TextDirection.rtl : TextDirection.ltr,
          );
          expect(tester.takeException(), isNull);
        });
      }
    }

    testWidgets('plots identical data in the same order in both locales', (
      tester,
    ) async {
      Future<List<FlSpot>> spotsFor(AppLocale locale) async {
        await _useLocale(tester, locale);
        await tester.pumpWidget(_directionalChart(_homeStyleChart(), locale));
        await tester.pump();
        return _lineChart(tester).data.lineBarsData.single.spots;
      }

      final english = await spotsFor(AppLocale.en);
      final arabic = await spotsFor(AppLocale.ar);

      expect(english, hasLength(45));
      expect(english.first.x, 0);
      expect(english.last.x, 44);
      expect(arabic.map((s) => s.x).toList(), [
        for (final spot in english) spot.x,
      ]);
      expect(arabic.map((s) => s.y).toList(), [
        for (final spot in english) spot.y,
      ]);
    });

    testWidgets('renders localized, single-line value labels in Arabic', (
      tester,
    ) async {
      await _useLocale(tester, AppLocale.ar);
      await tester.pumpWidget(
        _directionalChart(_homeStyleChart(), AppLocale.ar),
      );
      await tester.pump();

      final chartTexts = tester.widgetList<Text>(
        find.descendant(
          of: find.byType(LineChart),
          matching: find.byType(Text),
        ),
      );

      // Bottom-axis dates come from the central formatter, so they render
      // whatever the active locale produces rather than a hard-coded string.
      final firstDate = DateFormatter.formatShort(DateTime(2026, 7, 1));
      expect(firstDate.contains('Jul'), isFalse);
      expect(find.text(firstDate), findsOneWidget);

      final dateLabels = chartTexts
          .where((text) => text.data != null && text.maxLines == null)
          .map((text) => text.data!)
          .toList();
      expect(dateLabels, hasLength(inInclusiveRange(4, 6)));
      expect(
        dateLabels.any((label) => RegExp(r'^[A-Za-z]{3} \d').hasMatch(label)),
        isFalse,
        reason: 'a bottom label fell back to English',
      );

      final valueLabels = chartTexts.where(
        (text) => text.data != null && text.maxLines == 1,
      );
      expect(valueLabels, isNotEmpty);

      final reserved = _lineChart(
        tester,
      ).data.titlesData.leftTitles.sideTitles.reservedSize;
      expect(reserved, greaterThan(Responsive.adapt(44)));
    });

    testWidgets('leaves the English label strip exactly as it was', (
      tester,
    ) async {
      await tester.pumpWidget(
        _directionalChart(_homeStyleChart(), AppLocale.en),
      );
      await tester.pump();

      final chartTexts = tester.widgetList<Text>(
        find.descendant(
          of: find.byType(LineChart),
          matching: find.byType(Text),
        ),
      );
      expect(chartTexts.where((text) => text.maxLines == 1), isEmpty);
      expect(
        _lineChart(tester).data.titlesData.leftTitles.sideTitles.reservedSize,
        Responsive.adapt(44),
      );
    });

    testWidgets('draws the tooltip LTR and clamped inside the chart', (
      tester,
    ) async {
      await _useLocale(tester, AppLocale.ar);
      await tester.pumpWidget(
        _directionalChart(_homeStyleChart(), AppLocale.ar),
      );
      await tester.pump();

      final data = _lineChart(tester).data;
      final tooltip = data.lineTouchData.touchTooltipData;
      expect(tooltip.fitInsideHorizontally, isTrue);
      expect(tooltip.fitInsideVertically, isTrue);

      final item = tooltip.getTooltipItems([
        LineBarSpot(
          data.lineBarsData.single,
          0,
          data.lineBarsData.single.spots.first,
        ),
      ]).single!;

      expect(item.textDirection, TextDirection.ltr);
      expect(item.text, contains('يوليو'));
    });

    testWidgets('gives the chart one localized screen-reader summary', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      try {
        await _useLocale(tester, AppLocale.ar);
        await tester.pumpWidget(
          _directionalChart(_homeStyleChart(), AppLocale.ar),
        );
        await tester.pump();

        expect(
          find.bySemanticsLabel(
            RegExp(RegExp.escape(t.charts.semantics.realValue)),
          ),
          findsOneWidget,
        );
        final semantics = tester.widget<Semantics>(
          find.descendant(
            of: find.byType(AppChartDirectionality),
            matching: find.byType(Semantics),
          ),
        );
        expect(semantics.properties.textDirection, TextDirection.rtl);
      } finally {
        handle.dispose();
      }
    });
  });
}

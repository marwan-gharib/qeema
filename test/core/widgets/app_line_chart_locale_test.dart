import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/helpers/date_formatter.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/widgets/app_chart_directionality.dart';
import 'package:qeema/core/widgets/app_line_chart.dart';

import 'app_line_chart_fixtures.dart';

/// Locale behavior of [AppLineChart]: the plot is always LTR whatever the
/// locale, labels and the screen-reader summary follow the active locale, and
/// the tooltip stays clamped and direction-pinned. Style knobs live in
/// `app_line_chart_test.dart`.
void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('ar');
  });

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
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

          await useLocale(tester, locale);
          await tester.pumpWidget(
            directionalChartHarness(homeStyleChart(), locale),
          );
          await tester.pump();

          expect(chartDirection(tester), TextDirection.ltr);
          expect(
            Directionality.of(tester.element(find.byKey(chartSiblingKey))),
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
        await useLocale(tester, locale);
        await tester.pumpWidget(
          directionalChartHarness(homeStyleChart(), locale),
        );
        await tester.pump();
        return lineChartOf(tester).data.lineBarsData.single.spots;
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

    testWidgets('renders localized date and value labels in Arabic', (
      tester,
    ) async {
      await useLocale(tester, AppLocale.ar);
      await tester.pumpWidget(
        directionalChartHarness(homeStyleChart(), AppLocale.ar),
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

      expect(
        chartTexts.where(
          (text) =>
              text.data != null &&
              RegExp(r'^[A-Za-z]{3} \d').hasMatch(text.data!),
        ),
        isEmpty,
        reason: 'a bottom label fell back to English',
      );

      // Axis labels stay single-line in every locale; Arabic digits render
      // through the localized compact formatter.
      final axisLabels = chartTexts
          .where((text) => text.data != null && text.maxLines == 1)
          .map((text) => text.data!)
          .toList();
      expect(axisLabels, isNotEmpty);
      expect(
        axisLabels.any((label) => RegExp(r'^\d+(\.\d{2})?K$').hasMatch(label)),
        isFalse,
        reason: 'a value label fell back to English compact notation',
      );

      // The label strip is measured from the widest localized tick, which is
      // wider than the fixed fallback the English strip clamps to.
      expect(
        lineChartOf(tester).data.titlesData.leftTitles.sideTitles.reservedSize,
        greaterThan(Responsive.adapt(44)),
      );
    });

    testWidgets('renders English date and value labels in English', (
      tester,
    ) async {
      await tester.pumpWidget(
        directionalChartHarness(homeStyleChart(), AppLocale.en),
      );
      await tester.pump();

      final chartTexts = tester.widgetList<Text>(
        find.descendant(
          of: find.byType(LineChart),
          matching: find.byType(Text),
        ),
      );

      final dateLabels = chartTexts
          .where(
            (text) =>
                text.data != null &&
                RegExp(r'^[A-Za-z]{3} \d{1,2}$').hasMatch(text.data!),
          )
          .length;
      expect(dateLabels, inInclusiveRange(4, 6));
      expect(find.text('Jul 1'), findsOneWidget);

      final valueLabels = chartTexts.where(
        (text) =>
            text.data != null &&
            RegExp(r'^\d+(\.\d{2})?K$').hasMatch(text.data!),
      );
      expect(valueLabels, isNotEmpty);
    });

    testWidgets('draws the tooltip LTR and clamped inside the chart', (
      tester,
    ) async {
      await useLocale(tester, AppLocale.ar);
      await tester.pumpWidget(
        directionalChartHarness(homeStyleChart(), AppLocale.ar),
      );
      await tester.pump();

      final data = lineChartOf(tester).data;
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
        await useLocale(tester, AppLocale.ar);
        await tester.pumpWidget(
          directionalChartHarness(homeStyleChart(), AppLocale.ar),
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

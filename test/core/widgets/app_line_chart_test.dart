import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/widgets/app_line_chart.dart';

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

LineChart _lineChart(WidgetTester tester) {
  return tester.widget<LineChart>(find.byType(LineChart));
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  group('home-style chart (defaults)', () {
    testWidgets('renders a sized chart with all 45 spots', (tester) async {
      await tester.pumpWidget(
        _chart(
          AppLineChart(
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
}

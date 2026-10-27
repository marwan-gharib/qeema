import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/widgets/app_line_chart.dart';
import 'package:qeema/features/market_prices/presentation/widgets/price_sparkline.dart';

List<(DateTime, Decimal)> _points(int count) {
  return [
    for (var i = 0; i < count; i++)
      (DateTime(2026, 8, 8 + i), Decimal.parse('${120 + i}')),
  ];
}

Widget _harness(PriceSparkline sparkline) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: sparkline),
    ),
  );
}

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  testWidgets('renders nothing with fewer than two points', (tester) async {
    await tester.pumpWidget(
      _harness(PriceSparkline(points: _points(1), isGain: true)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppLineChart), findsNothing);
  });

  testWidgets('renders the mini chart for a full week of points', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(PriceSparkline(points: _points(7), isGain: true)),
    );
    await tester.pumpAndSettle();

    final chart = tester.widget<AppLineChart>(find.byType(AppLineChart));
    expect(chart.showAxisLabels, isFalse);
    expect(chart.showTooltip, isFalse);
    expect(chart.points, hasLength(7));
  });

  testWidgets(
    'uses the gain color for a rising week and the loss color otherwise',
    (tester) async {
      await tester.pumpWidget(
        _harness(PriceSparkline(points: _points(7), isGain: true)),
      );
      await tester.pumpAndSettle();
      final gainColor = tester
          .widget<AppLineChart>(find.byType(AppLineChart))
          .lineColor;

      await tester.pumpWidget(
        _harness(PriceSparkline(points: _points(7), isGain: false)),
      );
      await tester.pumpAndSettle();
      final lossColor = tester
          .widget<AppLineChart>(find.byType(AppLineChart))
          .lineColor;

      expect(gainColor, isNot(lossColor));
    },
  );
}

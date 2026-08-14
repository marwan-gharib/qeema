import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/presentation/widgets/market_price_chart.dart';

List<MarketPriceEntity> _history(int points, {double baseValue = 80000}) {
  return [
    for (var i = 0; i < points; i++)
      MarketPriceEntity(
        priceDate: DateTime(2026, 7, 1 + i),
        price: Decimal.fromInt((baseValue + i).toInt()),
      ),
  ];
}

Widget _chart(List<MarketPriceEntity> history) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: MarketPriceChart(priceHistory: history)),
    ),
  );
}

Finder _contentSizedBox() {
  return find.byWidgetPredicate(
    (widget) => widget is SizedBox && widget.height == 250,
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  group('axis labels', () {
    testWidgets('renders sparse bottom date labels', (tester) async {
      await tester.pumpWidget(_chart(_history(45)));
      await tester.pump();

      final dateLabels = tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(LineChart),
              matching: find.byType(Text),
            ),
          )
          .where(
            (text) =>
                text.data != null &&
                RegExp(r'^[A-Za-z]{3} \d{1,2}$').hasMatch(text.data!),
          );

      expect(dateLabels.length, inInclusiveRange(4, 6));
      expect(find.text('Jul 1'), findsOneWidget);
    });

    testWidgets('renders compact left value labels', (tester) async {
      await tester.pumpWidget(_chart(_history(45)));
      await tester.pump();

      final valueLabels = tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(LineChart),
              matching: find.byType(Text),
            ),
          )
          .where(
            (text) =>
                text.data != null &&
                RegExp(r'^\d+(\.\d{2})?K$').hasMatch(text.data!),
          );

      expect(valueLabels, isNotEmpty);
    });
  });

  group('fixed size', () {
    testWidgets('chart fills the available width at fixed height', (
      tester,
    ) async {
      await tester.pumpWidget(_chart(_history(45)));
      await tester.pump();

      final box = tester.widget<SizedBox>(_contentSizedBox());
      expect(box.height, 250);
      expect(box.width, isNull);
      expect(
        tester.getSize(find.byType(LineChart)).width,
        tester.getSize(_contentSizedBox()).width,
      );
    });

    testWidgets('renders without any zoom or scroll chrome', (tester) async {
      await tester.pumpWidget(_chart(_history(45)));
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsNothing);
      expect(find.byType(Scrollable), findsNothing);
    });
  });
}

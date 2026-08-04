import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/home/domain/entities/portfolio_snapshot_entity.dart';
import 'package:qeema/features/home/presentation/widgets/real_value_trend_chart.dart';

List<PortfolioSnapshotEntity> _trend(int points, {double baseValue = 80000}) {
  return [
    for (var i = 0; i < points; i++)
      PortfolioSnapshotEntity(
        date: DateTime(2026, 7, 1 + i),
        realTotal: Decimal.fromInt((baseValue + i).toInt()),
      ),
  ];
}

Widget _chart(List<PortfolioSnapshotEntity> trend) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: RealValueTrendChart(trendData: trend)),
    ),
  );
}

Finder _contentSizedBox() {
  return find.byWidgetPredicate(
    (widget) => widget is SizedBox && widget.height == 250,
  );
}

Finder _emptyStateContainer() {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Container &&
        widget.constraints is BoxConstraints &&
        (widget.constraints as BoxConstraints).maxHeight == 250,
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
      await tester.pumpWidget(_chart(_trend(45)));
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
      await tester.pumpWidget(_chart(_trend(45)));
      await tester.pump();

      expect(find.text('80K'), findsWidgets);
    });
  });

  group('fixed width', () {
    testWidgets('chart fills the available width at fixed height', (
      tester,
    ) async {
      await tester.pumpWidget(_chart(_trend(45)));
      await tester.pump();

      final box = tester.widget<SizedBox>(_contentSizedBox());
      expect(box.height, 250);
      expect(box.width, isNull);
      expect(
        tester.getSize(find.byType(LineChart)).width,
        tester.getSize(find.byType(RealValueTrendChart)).width,
      );
    });

    testWidgets('renders without any zoom or scroll chrome', (tester) async {
      await tester.pumpWidget(_chart(_trend(45)));
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsNothing);
      expect(find.byType(Scrollable), findsNothing);
    });
  });

  group('empty state', () {
    testWidgets('renders at the same height as the chart', (tester) async {
      await tester.pumpWidget(_chart(_trend(1)));
      await tester.pump();

      expect(find.byType(LineChart), findsNothing);
      expect(_emptyStateContainer(), findsOneWidget);
    });
  });
}

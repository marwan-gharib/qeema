import 'package:decimal/decimal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_value_chart_content.dart';

final _usdAsset = AssetEntity(
  id: 'asset-1',
  assetType: AssetType.usdCash,
  amount: 300,
  priceAtEntry: 47.747,
  entryDate: DateTime(2026, 7, 20),
);

final _egpCashAsset = AssetEntity(
  id: 'asset-2',
  assetType: AssetType.egpCash,
  amount: 25000,
  priceAtEntry: 1,
  entryDate: DateTime(2026, 7, 20),
);

List<MarketPriceEntity> _history(int points) {
  return [
    for (var i = 0; i < points; i++)
      MarketPriceEntity(
        priceDate: DateTime(2026, 7, 20 + i),
        price: Decimal.fromInt(47000 + i),
      ),
  ];
}

Widget _chart({
  required AssetEntity asset,
  List<MarketPriceEntity>? priceHistory,
}) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: AssetValueChartBody(asset: asset, priceHistory: priceHistory),
      ),
    ),
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

  group('AssetValueChartBody', () {
    testWidgets('renders the fl_chart line chart when given 2+ price points', (
      tester,
    ) async {
      await tester.pumpWidget(
        _chart(asset: _usdAsset, priceHistory: _history(3)),
      );

      expect(find.byIcon(Icons.show_chart), findsNothing);
      expect(find.text('Value Trend'), findsOneWidget);
      expect(find.byType(LineChart), findsOneWidget);
      expect(find.text('Jul 20'), findsOneWidget);
    });

    testWidgets('renders empty state when given fewer than 2 price points', (
      tester,
    ) async {
      await tester.pumpWidget(
        _chart(asset: _usdAsset, priceHistory: _history(1)),
      );

      expect(find.byIcon(Icons.show_chart), findsOneWidget);
      expect(find.text('Not enough price history yet'), findsOneWidget);
    });

    testWidgets('renders empty state when price history is null', (
      tester,
    ) async {
      await tester.pumpWidget(_chart(asset: _usdAsset, priceHistory: null));

      expect(find.byIcon(Icons.show_chart), findsOneWidget);
    });

    testWidgets('empty state matches the real chart height', (tester) async {
      await tester.pumpWidget(_chart(asset: _usdAsset, priceHistory: null));

      expect(_emptyStateContainer(), findsOneWidget);
    });

    testWidgets('cash asset renders flat-line without empty state', (
      tester,
    ) async {
      await tester.pumpWidget(
        _chart(asset: _egpCashAsset, priceHistory: _history(2)),
      );

      expect(find.byIcon(Icons.show_chart), findsNothing);
      expect(find.byType(LineChart), findsNothing);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is CustomPaint && widget.size.height == 48,
        ),
        findsOneWidget,
      );
      expect(
        find.text('Cash assets maintain a constant value'),
        findsOneWidget,
      );
    });
  });
}

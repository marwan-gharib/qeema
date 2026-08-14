import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_summary_entity.dart';
import 'package:qeema/features/market_prices/presentation/widgets/market_price_card.dart';
import 'package:qeema/features/market_prices/presentation/widgets/price_change_badge.dart';
import 'package:qeema/features/market_prices/presentation/widgets/price_sparkline.dart';
import 'package:qeema/features/market_prices/presentation/widgets/stale_data_indicator.dart';

const _usdType = AssetTypeEntity(
  id: 'type-usd',
  code: 'usd',
  name: 'US Dollar',
  isMarketBased: true,
  baseUnit: 'USD',
);

List<MarketPricePointEntity> _points() {
  return [
    for (var i = 0; i < 7; i++)
      MarketPricePointEntity(
        date: DateTime(2026, 8, 8 + i),
        price: Decimal.parse('120'),
      ),
  ];
}

Widget _wrap(Widget child) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  group('MarketPriceCard', () {
    testWidgets('shows name, formatted price, badge and sparkline', (
      tester,
    ) async {
      final summary = MarketPriceSummaryEntity(
        assetType: _usdType,
        todayPrice: Decimal.parse('6178.89'),
        todayPriceDate: DateTime(2026, 8, 14),
        fetchedAt: DateTime.now().subtract(const Duration(hours: 2)),
        weeklyChangePercent: Decimal.parse('1.5'),
        sparklinePoints: _points(),
      );

      await tester.pumpWidget(_wrap(MarketPriceCard(summary: summary)));
      await tester.pump();

      expect(find.text('US Dollar'), findsOneWidget);
      expect(find.text('EGP 6178.89'), findsOneWidget);
      expect(find.byType(PriceChangeBadge), findsOneWidget);
      expect(find.byType(PriceSparkline), findsOneWidget);
      expect(find.byType(StaleDataIndicator), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
    });

    testWidgets('hides badge value and sparkline when there is no history', (
      tester,
    ) async {
      final summary = const MarketPriceSummaryEntity(
        assetType: _usdType,
        todayPrice: null,
        todayPriceDate: null,
        fetchedAt: null,
        weeklyChangePercent: null,
        sparklinePoints: [],
      );

      await tester.pumpWidget(_wrap(MarketPriceCard(summary: summary)));
      await tester.pump();

      // Price placeholder and badge dash both render "—".
      expect(find.text('—'), findsNWidgets(2));
      expect(find.byType(PriceSparkline), findsNothing);
      expect(find.byType(StaleDataIndicator), findsNothing);
      expect(find.text(t.marketPrices.notEnoughHistory), findsOneWidget);
    });

    testWidgets('flags stale data when fetchedAt is older than 36h', (
      tester,
    ) async {
      final summary = MarketPriceSummaryEntity(
        assetType: _usdType,
        todayPrice: Decimal.parse('6178.89'),
        todayPriceDate: DateTime(2026, 8, 14),
        fetchedAt: DateTime.now().subtract(const Duration(hours: 40)),
        weeklyChangePercent: Decimal.parse('-0.5'),
        sparklinePoints: _points(),
      );

      await tester.pumpWidget(_wrap(MarketPriceCard(summary: summary)));
      await tester.pump();

      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.text(t.marketPrices.notEnoughHistory), findsNothing);
    });
  });
}

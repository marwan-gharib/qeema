import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_price_detail_cubit/market_price_detail_state.dart';
import 'package:qeema/features/market_prices/presentation/widgets/range_selector_chips.dart';

Widget _harness(RangeSelectorChips chips) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: chips),
    ),
  );
}

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  testWidgets('renders the three range chips with the selection marked', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        RangeSelectorChips(
          selected: MarketPriceRangeOption.oneMonth,
          onSelected: (_) {},
        ),
      ),
    );

    final week = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, t.marketPrices.range.oneWeek),
    );
    final month = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, t.marketPrices.range.oneMonth),
    );
    final quarter = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, t.marketPrices.range.threeMonths),
    );

    expect(week.selected, isFalse);
    expect(month.selected, isTrue);
    expect(quarter.selected, isFalse);
  });

  testWidgets('tapping a chip reports the chosen option', (tester) async {
    MarketPriceRangeOption? chosen;
    await tester.pumpWidget(
      _harness(
        RangeSelectorChips(
          selected: MarketPriceRangeOption.oneWeek,
          onSelected: (option) => chosen = option,
        ),
      ),
    );

    await tester.tap(
      find.widgetWithText(ChoiceChip, t.marketPrices.range.threeMonths),
    );

    expect(chosen, MarketPriceRangeOption.threeMonths);
  });
}

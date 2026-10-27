import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/market_prices/presentation/widgets/stale_data_indicator.dart';

Widget _harness(StaleDataIndicator indicator) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: indicator),
    ),
  );
}

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  testWidgets('shows the updated-ago caption for a fresh timestamp', (
    tester,
  ) async {
    final fetchedAt = DateTime.now().subtract(const Duration(hours: 2));

    await tester.pumpWidget(_harness(StaleDataIndicator(fetchedAt: fetchedAt)));

    expect(
      find.text(t.marketPrices.lastUpdated(when: t.core.dates.hoursAgo(n: 2))),
      findsOneWidget,
    );
  });

  testWidgets('shows the warning icon only when the data is stale', (
    tester,
  ) async {
    final fetchedAt = DateTime.now().subtract(const Duration(hours: 40));

    await tester.pumpWidget(
      _harness(StaleDataIndicator(fetchedAt: fetchedAt, isStale: true)),
    );
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

    await tester.pumpWidget(
      _harness(StaleDataIndicator(fetchedAt: fetchedAt, isStale: false)),
    );
    expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
  });
}

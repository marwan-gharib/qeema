import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/market_prices/presentation/widgets/data_source_disclosure.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  testWidgets('renders the spot-rates disclosure copy', (tester) async {
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: DataSourceDisclosure()),
        ),
      ),
    );

    expect(find.text(t.marketPrices.dataSourceDisclosure), findsOneWidget);
  });
}

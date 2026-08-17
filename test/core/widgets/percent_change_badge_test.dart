import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/widgets/percent_change_badge.dart';

Widget _wrap(Widget child) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets('gain renders an up arrow with the signed percent', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(PercentChangeBadge(percent: Decimal.parse('2.5'))),
    );

    expect(find.text('2.5%'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    expect(find.byIcon(Icons.arrow_downward), findsNothing);
  });

  testWidgets('loss renders a down arrow with the signed percent', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(PercentChangeBadge(percent: Decimal.parse('-1.5'))),
    );

    expect(find.text('-1.5%'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
  });

  testWidgets('zero percent is treated as a gain', (tester) async {
    await tester.pumpWidget(_wrap(PercentChangeBadge(percent: Decimal.zero)));

    expect(find.text('0.0%'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
  });

  testWidgets('null percent renders a muted dash', (tester) async {
    await tester.pumpWidget(_wrap(const PercentChangeBadge()));

    expect(find.text('—'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward), findsNothing);
    expect(find.byIcon(Icons.arrow_downward), findsNothing);
  });
}

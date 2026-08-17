import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/widgets/app_empty_state.dart';

Widget _wrap(Widget child) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets('centered variant shows icon, title, subtitle, and action', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AppEmptyState(
          icon: Icons.inbox,
          title: 'Nothing here',
          subtitle: 'Add something',
          actionLabel: 'Add first',
          onAction: () {},
        ),
      ),
    );

    expect(find.byIcon(Icons.inbox), findsOneWidget);
    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.text('Add something'), findsOneWidget);
    expect(find.text('Add first'), findsOneWidget);

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.size, 64);
  });

  testWidgets('centered variant has no surface container', (tester) async {
    await tester.pumpWidget(
      _wrap(const AppEmptyState(icon: Icons.inbox, title: 'Nothing here')),
    );

    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).color != null,
      ),
      findsNothing,
    );
  });

  testWidgets('container variant renders a surface-alt box with fixed style', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AppEmptyState(
          icon: Icons.show_chart,
          title: 'Not enough price history yet',
          container: true,
          height: 250,
          padding: EdgeInsets.all(16),
        ),
      ),
    );

    final container = tester.widget<Container>(
      find.byWidgetPredicate(
        (w) => w is Container && w.constraints?.maxHeight == 250,
      ),
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular(12));

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.size, 48);
    expect(find.byType(FittedBox), findsOneWidget);
  });

  testWidgets('custom action widget replaces the label button', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AppEmptyState(
          icon: Icons.inbox,
          title: 'Nothing here',
          action: Text('Custom'),
        ),
      ),
    );

    expect(find.text('Custom'), findsOneWidget);
  });

  testWidgets('custom styles flow through to icon and title', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AppEmptyState(
          icon: Icons.inbox,
          title: 'Nothing here',
          iconColor: Colors.red,
          titleStyle: TextStyle(fontSize: 20),
        ),
      ),
    );

    expect(tester.widget<Icon>(find.byType(Icon)).color, Colors.red);
    expect(tester.widget<Text>(find.text('Nothing here')).style?.fontSize, 20);
  });
}

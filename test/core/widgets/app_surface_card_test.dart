import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/widgets/app_surface_card.dart';

Widget _wrap(Widget child) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets('renders the child on a surface-alt rounded box', (tester) async {
    await tester.pumpWidget(
      _wrap(const AppSurfaceCard(child: Text('Content'))),
    );

    expect(find.text('Content'), findsOneWidget);

    final container = tester.widget<Container>(
      find
          .ancestor(of: find.text('Content'), matching: find.byType(Container))
          .first,
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, isNotNull);
    expect(decoration.borderRadius, BorderRadius.circular(12));
  });

  testWidgets('applies custom padding and radius', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AppSurfaceCard(
          padding: EdgeInsets.all(24),
          borderRadius: 16,
          child: Text('Content'),
        ),
      ),
    );

    final container = tester.widget<Container>(
      find
          .ancestor(of: find.text('Content'), matching: find.byType(Container))
          .first,
    );
    expect(container.padding, const EdgeInsets.all(24));
    expect(
      (container.decoration! as BoxDecoration).borderRadius,
      BorderRadius.circular(16),
    );
  });

  testWidgets('no tap wrapper when onTap is null', (tester) async {
    await tester.pumpWidget(
      _wrap(const AppSurfaceCard(child: Text('Content'))),
    );

    expect(find.text('Content'), findsOneWidget);
  });

  testWidgets('tapping triggers onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        AppSurfaceCard(
          onTap: () => tapped = true,
          child: const Text('Content'),
        ),
      ),
    );

    await tester.tap(find.text('Content'));
    expect(tapped, isTrue);
  });
}

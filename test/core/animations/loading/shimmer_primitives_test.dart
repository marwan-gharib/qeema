import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';
import 'package:qeema/core/animations/loading/shimmer_card.dart';
import 'package:qeema/core/animations/loading/shimmer_line.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';

Widget _wrap(Widget child) {
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets('ShimmerLine defaults to a full-width 14px line', (tester) async {
    await tester.pumpWidget(_wrap(const ShimmerLine()));

    final box = tester.widget<ShimmerBox>(find.byType(ShimmerBox));
    expect(box.width, double.infinity);
    expect(box.height, 14);
    expect(box.borderRadius, 4);
  });

  testWidgets('ShimmerLine forwards custom dimensions', (tester) async {
    await tester.pumpWidget(
      _wrap(const ShimmerLine(width: 120, height: 32, borderRadius: 6)),
    );

    final box = tester.widget<ShimmerBox>(find.byType(ShimmerBox));
    expect(box.width, 120);
    expect(box.height, 32);
    expect(box.borderRadius, 6);
  });

  testWidgets('ShimmerCard defaults to a full-width 140px block', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ShimmerCard()));

    final box = tester.widget<ShimmerBox>(find.byType(ShimmerBox));
    expect(box.width, double.infinity);
    expect(box.height, 140);
    expect(box.borderRadius, 12);
  });

  testWidgets('ShimmerCard forwards custom dimensions', (tester) async {
    await tester.pumpWidget(
      _wrap(const ShimmerCard(width: 60, height: 20, borderRadius: 10)),
    );

    final box = tester.widget<ShimmerBox>(find.byType(ShimmerBox));
    expect(box.width, 60);
    expect(box.height, 20);
    expect(box.borderRadius, 10);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/responsive/responsive_scope.dart';

void main() {
  tearDown(Responsive.unbind);

  Widget buildApp({required Widget child}) {
    return MaterialApp(home: ResponsiveScope(child: child));
  }

  testWidgets('mounting the scope scales values against the screen', (
    tester,
  ) async {
    late double value;
    await tester.pumpWidget(
      buildApp(
        child: Builder(
          builder: (context) {
            value = Responsive.width(100);
            return const SizedBox();
          },
        ),
      ),
    );

    // Test surface is 800dp wide: 800/375 clamps to the 1.30 ceiling.
    expect(Responsive.isInitialized, isTrue);
    expect(value, closeTo(130, 0.001));
  });

  testWidgets('disposing the scope restores the identity transform', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(child: Builder(builder: (_) => const SizedBox())),
    );
    expect(Responsive.isInitialized, isTrue);

    await tester.pumpWidget(const SizedBox());

    expect(Responsive.isInitialized, isFalse);
    expect(Responsive.width(100), 100);
  });

  testWidgets('a screen resize re-runs scaled values downstream', (
    tester,
  ) async {
    final values = <double>[];
    await tester.pumpWidget(
      buildApp(
        child: Builder(
          builder: (context) {
            values.add(Responsive.width(100));
            return const SizedBox();
          },
        ),
      ),
    );
    expect(values.last, closeTo(130, 0.001));

    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pump();

    expect(values.length, greaterThan(1));
    expect(values.last, closeTo(100, 0.001));
  });

  testWidgets('clamps the system text scale to the 1.3 ceiling', (
    tester,
  ) async {
    late double textScale;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(3)),
          child: ResponsiveScope(
            child: Builder(
              builder: (context) {
                textScale = MediaQuery.textScalerOf(context).scale(1);
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );

    expect(textScale, closeTo(1.3, 0.001));
  });
}

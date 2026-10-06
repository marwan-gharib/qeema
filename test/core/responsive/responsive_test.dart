import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/responsive/responsive_scaler.dart';

class _FakeScaler extends ResponsiveScaler {
  bool configured = false;

  @override
  bool get isInitialized => configured;

  @override
  double width(double value) => configured ? value * 2 : value;

  @override
  double height(double value) => configured ? value * 3 : value;

  @override
  double radius(double value) => configured ? value * 2 : value;

  @override
  double font(double value) => configured ? value * 2 : value;

  @override
  double adapt(double value) => configured ? value * 2 : value;

  @override
  void configure(MediaQueryData metrics, {required Size designSize}) {
    configured = true;
  }

  @override
  Future<void> ensureInitialized() async {}
}

void main() {
  tearDown(Responsive.unbind);

  group('Responsive before configuration', () {
    test('isInitialized is false', () {
      expect(Responsive.isInitialized, isFalse);
    });

    test('every scale method returns its input unchanged', () {
      expect(Responsive.width(100), 100);
      expect(Responsive.height(100), 100);
      expect(Responsive.radius(100), 100);
      expect(Responsive.font(100), 100);
      expect(Responsive.adapt(100), 100);
    });
  });

  group('Responsive with ScreenUtil engine configured', () {
    setUp(() => Responsive.bindDefault());

    test('scales up and clamps at the 1.30 ceiling', () {
      Responsive.configure(
        const MediaQueryData(size: Size(750, 1624)),
        designSize: Responsive.designSize,
      );

      expect(Responsive.isInitialized, isTrue);
      expect(Responsive.width(100), closeTo(130, 0.001));
      expect(Responsive.height(100), closeTo(130, 0.001));
      expect(Responsive.adapt(100), closeTo(130, 0.001));
      expect(Responsive.radius(100), closeTo(130, 0.001));
      expect(Responsive.font(100), closeTo(130, 0.001));
    });

    test('scales down and clamps at the 0.85 floor', () {
      Responsive.configure(
        const MediaQueryData(size: Size(300, 650)),
        designSize: Responsive.designSize,
      );

      expect(Responsive.width(100), closeTo(85, 0.001));
      expect(Responsive.height(100), closeTo(85, 0.001));
      expect(Responsive.adapt(100), closeTo(85, 0.001));
    });

    test('keeps the design baseline 1:1', () {
      Responsive.configure(
        const MediaQueryData(size: Responsive.designSize),
        designSize: Responsive.designSize,
      );

      expect(Responsive.width(100), 100);
      expect(Responsive.height(100), 100);
      expect(Responsive.adapt(100), 100);
    });

    test('an empty screen size falls back to identity', () {
      Responsive.configure(
        const MediaQueryData(size: Size.zero),
        designSize: Responsive.designSize,
      );

      expect(Responsive.isInitialized, isFalse);
      expect(Responsive.width(100), 100);
    });
  });

  group('Responsive engine swapping', () {
    test('bind routes every method through the bound engine', () {
      Responsive.bind(_FakeScaler());

      expect(Responsive.isInitialized, isFalse);
      expect(Responsive.width(10), 10);

      Responsive.configure(
        const MediaQueryData(size: Size(400, 800)),
        designSize: Responsive.designSize,
      );

      expect(Responsive.isInitialized, isTrue);
      expect(Responsive.width(10), 20);
      expect(Responsive.height(10), 30);
      expect(Responsive.radius(10), 20);
      expect(Responsive.font(10), 20);
      expect(Responsive.adapt(10), 20);
    });

    test('unbind restores the identity transform', () {
      Responsive.bind(_FakeScaler());
      Responsive.configure(
        const MediaQueryData(size: Size(400, 800)),
        designSize: Responsive.designSize,
      );
      expect(Responsive.width(10), 20);

      Responsive.unbind();

      expect(Responsive.isInitialized, isFalse);
      expect(Responsive.width(10), 10);
    });
  });
}

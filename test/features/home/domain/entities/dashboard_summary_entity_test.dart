import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';

DashboardSummaryEntity _summary({Decimal? nominalTotal, Decimal? realTotal}) {
  return DashboardSummaryEntity(
    nominalTotal: nominalTotal ?? Decimal.zero,
    realTotal: realTotal ?? Decimal.zero,
    assetTypeSummaries: const [],
    trend30Days: const [],
  );
}

void main() {
  group('DashboardSummaryEntity.erosionPercent', () {
    test('is zero when nominal total is zero', () {
      expect(_summary().erosionPercent, Decimal.zero);
    });

    test('is the real-to-nominal loss when real is below nominal', () {
      final summary = _summary(
        nominalTotal: Decimal.fromInt(1000),
        realTotal: Decimal.fromInt(900),
      );
      expect(summary.erosionPercent, Decimal.parse('10'));
    });

    test('clamps negative erosion to zero', () {
      final summary = _summary(
        nominalTotal: Decimal.fromInt(1000),
        realTotal: Decimal.fromInt(1100),
      );
      expect(summary.erosionPercent, Decimal.zero);
    });

    test('clamps erosion above 100 to 100', () {
      final summary = _summary(
        nominalTotal: Decimal.fromInt(100),
        realTotal: Decimal.zero,
      );
      expect(summary.erosionPercent, Decimal.fromInt(100));
    });
  });

  group('DashboardSummaryEntity.hasAssets', () {
    test('is false when nominal total is zero', () {
      expect(_summary().hasAssets, isFalse);
    });

    test('is true when nominal total is positive', () {
      expect(_summary(nominalTotal: Decimal.one).hasAssets, isTrue);
    });
  });
}

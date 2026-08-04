import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/helpers/currency_formatter.dart';

void main() {
  test('formatCompact trims trailing zero in K range', () {
    expect(CurrencyFormatter.formatCompact(Decimal.parse('80000')), '80K');
  });

  test('formatCompact keeps one decimal in M range', () {
    expect(CurrencyFormatter.formatCompact(Decimal.parse('1250000')), '1.3M');
  });

  test('formatCompact formats small values with two decimals', () {
    expect(CurrencyFormatter.formatCompact(Decimal.parse('996')), '996.00');
  });

  test('formatCompact handles negative values', () {
    expect(CurrencyFormatter.formatCompact(Decimal.parse('-80000')), '-80K');
  });
}

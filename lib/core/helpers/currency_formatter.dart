import 'package:decimal/decimal.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  static Decimal _d(dynamic v) => Decimal.parse(v.toString());

  static String format(
    Decimal amount, {
    String symbol = 'EGP',
    int decimalPlaces = 2,
  }) {
    final formatted = amount.toStringAsFixed(decimalPlaces);
    return '$symbol $formatted';
  }

  static String formatCompact(Decimal amount) {
    final abs = amount.abs();
    if (abs >= Decimal.fromInt(1000000)) {
      return '${_d(amount / Decimal.fromInt(1000000)).toStringAsFixed(1)}M';
    } else if (abs >= Decimal.fromInt(1000)) {
      return '${_d(amount / Decimal.fromInt(1000)).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(2);
  }
}

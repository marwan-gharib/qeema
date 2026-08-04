import 'package:decimal/decimal.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

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
    String formatted;
    String suffix;
    if (abs >= Decimal.fromInt(1000000)) {
      formatted = _unitValue(amount, Decimal.fromInt(1000000));
      suffix = 'M';
    } else if (abs >= Decimal.fromInt(1000)) {
      formatted = _unitValue(amount, Decimal.fromInt(1000));
      suffix = 'K';
    } else {
      return amount.toStringAsFixed(2);
    }
    if (formatted.endsWith('.0')) {
      formatted = formatted.substring(0, formatted.length - 2);
    }
    return '$formatted$suffix';
  }

  static String _unitValue(Decimal amount, Decimal unit) {
    return (amount / unit).toDouble().toStringAsFixed(1);
  }
}

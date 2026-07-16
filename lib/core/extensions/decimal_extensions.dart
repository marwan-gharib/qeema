import 'package:decimal/decimal.dart';

extension DecimalFormatting on Decimal {
  String toCurrency({int decimalPlaces = 2}) {
    return toStringAsFixed(decimalPlaces);
  }

  String toPercentage({int decimalPlaces = 1}) {
    return '${(this * Decimal.fromInt(100)).toStringAsFixed(decimalPlaces)}%';
  }

  Decimal roundTo(int places) {
    return Decimal.parse(toStringAsFixed(places));
  }
}

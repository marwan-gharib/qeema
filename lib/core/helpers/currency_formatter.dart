import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:qeema/core/i18n/strings.g.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  static String format(
    Decimal amount, {
    String symbol = 'EGP',
    int decimalPlaces = 2,
    String? locale,
  }) {
    final formatted = NumberFormat.decimalPattern(_locale(locale))
      ..minimumFractionDigits = decimalPlaces
      ..maximumFractionDigits = decimalPlaces;
    return '${currencyName(symbol)} ${formatted.format(amount.toDouble())}';
  }

  static String formatCompact(
    Decimal amount, {
    int decimalPlaces = 1,
    String? locale,
  }) {
    final formatter = NumberFormat.compact(locale: _locale(locale))
      ..maximumFractionDigits = decimalPlaces;
    return formatter.format(amount.toDouble());
  }

  static String _locale(String? locale) =>
      locale ?? LocaleSettings.currentLocale.languageCode;

  static String currencyName(String code) {
    return switch (code) {
      'EGP' => t.core.currency.egp,
      'USD' => t.core.currency.usd,
      _ => code,
    };
  }
}

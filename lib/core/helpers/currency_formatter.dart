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
    return '${formatted.format(amount.toDouble())} ${currencyName(symbol)}';
  }

  static String formatCompact(
    Decimal amount, {
    int decimalPlaces = 1,
    String? locale,
  }) {
    final localeName = _locale(locale);
    // Below the compact range the short scale would drop the cents, so small
    // amounts always keep two decimals ('996.00', never '996').
    if (amount.abs() < Decimal.fromInt(1000)) {
      final plain = NumberFormat.decimalPattern(localeName)
        ..minimumFractionDigits = 2
        ..maximumFractionDigits = 2;
      return plain.format(amount.toDouble());
    }
    final formatter = NumberFormat.compact(locale: localeName)
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

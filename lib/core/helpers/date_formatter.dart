import 'package:intl/intl.dart';
import 'package:qeema/core/i18n/strings.g.dart';

class DateFormatter {
  const DateFormatter._();

  static String format(DateTime date, {String? locale}) {
    return DateFormat.yMd(_locale(locale)).format(date);
  }

  static String monthYear(DateTime date, {String? locale}) {
    return DateFormat.yMMM(_locale(locale)).format(date);
  }

  static String formatShort(DateTime date, {String? locale}) {
    return DateFormat('MMM d', _locale(locale)).format(date);
  }

  static String _locale(String? locale) =>
      locale ?? LocaleSettings.currentLocale.languageCode;
}

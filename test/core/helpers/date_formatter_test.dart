import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qeema/core/helpers/date_formatter.dart';
import 'package:qeema/core/i18n/strings.g.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  test('formatShort renders MMM d style', () {
    expect(DateFormatter.formatShort(DateTime(2026, 1, 12)), 'Jan 12');
  });

  test('formatShort pads single-digit days', () {
    expect(DateFormatter.formatShort(DateTime(2026, 8, 4)), 'Aug 4');
  });
}

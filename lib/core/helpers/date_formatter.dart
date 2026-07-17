class DateFormatter {
  const DateFormatter._();

  static String format(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String monthYear(DateTime date) {
    return '${date.year}';
  }
}

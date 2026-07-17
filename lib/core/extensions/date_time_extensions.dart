extension DateTimeFormatting on DateTime {
  String toDisplayDate() {
    return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  DateTime get startOfMonth => DateTime(year, month);
  DateTime get endOfMonth => DateTime(year, month + 1, 0);
  DateTime get normalizedMonth => DateTime(year, month);
}

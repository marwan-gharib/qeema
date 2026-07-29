class InflationRateRow {
  const InflationRateRow({
    required this.year,
    required this.month,
    required this.monthlyRatePercent,
  });

  factory InflationRateRow.fromJson(Map<String, dynamic> json) {
    final monthStr = json['month'] as String;
    final dt = DateTime.parse(monthStr);
    final rate = (json['rate'] as num).toDouble();
    return InflationRateRow(
      year: dt.year,
      month: dt.month,
      monthlyRatePercent: rate * 100,
    );
  }

  final int year;
  final int month;
  final double monthlyRatePercent;
}

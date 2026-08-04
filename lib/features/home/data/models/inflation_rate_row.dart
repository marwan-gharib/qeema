import 'package:decimal/decimal.dart';

class InflationRateRow {
  const InflationRateRow({required this.month, required this.rate});

  factory InflationRateRow.fromJson(Map<String, dynamic> json) {
    return InflationRateRow(
      month: DateTime.parse(json['month'] as String),
      rate: Decimal.parse((json['rate'] as num).toString()),
    );
  }

  final DateTime month;

  /// Monthly rate as a decimal fraction — 0.018 means 1.8%.
  final Decimal rate;
}

import 'package:decimal/decimal.dart';

class MonthlyInflationRate {
  final DateTime month;
  final Decimal rate;

  const MonthlyInflationRate({required this.month, required this.rate});
}

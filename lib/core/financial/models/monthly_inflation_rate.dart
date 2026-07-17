import 'package:decimal/decimal.dart';

class MonthlyInflationRate {
  const MonthlyInflationRate({required this.month, required this.rate});
  final DateTime month;
  final Decimal rate;
}

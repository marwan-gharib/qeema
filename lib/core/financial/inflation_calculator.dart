import 'package:decimal/decimal.dart';

import '../error/failures.dart';
import '../utils/api_result.dart';
import 'models/monthly_inflation_rate.dart';

class InflationCalculator {
  Decimal _d(dynamic v) => Decimal.parse(v.toString());

  ApiResult<Decimal> calculateRealValue({
    required Decimal nominalValue,
    required List<MonthlyInflationRate> ratesInRange,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    if (fromDate.isAtSameMomentAs(toDate) ||
        (fromDate.year == toDate.year && fromDate.month == toDate.month)) {
      return Success(nominalValue);
    }
    if (ratesInRange.isEmpty) {
      return ResultFailure(InflationDataMissingFailure([fromDate]));
    }
    final missing = _findMissingMonths(ratesInRange, fromDate, toDate);
    if (missing.isNotEmpty) {
      return ResultFailure(InflationDataMissingFailure(missing));
    }
    var compoundFactor = Decimal.one;
    for (final r in ratesInRange) {
      compoundFactor *= (Decimal.one + r.rate);
    }
    if (compoundFactor == Decimal.zero) {
      return ResultFailure(
        CalculationFailure('Compound factor resolved to zero'),
      );
    }
    return Success(_d(nominalValue / compoundFactor));
  }

  List<DateTime> _findMissingMonths(
    List<MonthlyInflationRate> rates,
    DateTime from,
    DateTime to,
  ) {
    final present = rates
        .map((r) => DateTime(r.month.year, r.month.month))
        .toSet();

    final missing = <DateTime>[];
    var current = DateTime(from.year, from.month);
    final end = DateTime(to.year, to.month);

    while (!current.isAfter(end)) {
      if (!present.contains(current)) {
        missing.add(current);
      }
      current = DateTime(current.year, current.month + 1);
    }
    return missing;
  }
}

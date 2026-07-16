import 'package:decimal/decimal.dart';

class PortfolioSnapshotData {
  final Decimal nominalValue;
  final Decimal realValue;
  final DateTime snapshotDate;

  const PortfolioSnapshotData({
    required this.nominalValue,
    required this.realValue,
    required this.snapshotDate,
  });
}

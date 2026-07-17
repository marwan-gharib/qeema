import 'package:decimal/decimal.dart';

class PortfolioSnapshotData {
  const PortfolioSnapshotData({
    required this.nominalValue,
    required this.realValue,
    required this.snapshotDate,
  });
  final Decimal nominalValue;
  final Decimal realValue;
  final DateTime snapshotDate;
}

import 'package:decimal/decimal.dart';

class PortfolioSnapshotEntity {
  const PortfolioSnapshotEntity({required this.date, required this.realTotal});

  final DateTime date;
  final Decimal realTotal;
}

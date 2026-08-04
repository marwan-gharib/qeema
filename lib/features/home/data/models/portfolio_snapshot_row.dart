import 'package:decimal/decimal.dart';

class PortfolioSnapshotRow {
  const PortfolioSnapshotRow({
    required this.snapshotDate,
    required this.totalNominalValue,
    required this.totalRealValue,
  });

  factory PortfolioSnapshotRow.fromJson(Map<String, dynamic> json) {
    return PortfolioSnapshotRow(
      snapshotDate: DateTime.parse(json['snapshot_date'] as String),
      totalNominalValue: Decimal.parse(
        (json['total_nominal_value'] as num).toString(),
      ),
      totalRealValue: Decimal.parse(
        (json['total_real_value'] as num).toString(),
      ),
    );
  }

  final DateTime snapshotDate;
  final Decimal totalNominalValue;
  final Decimal totalRealValue;
}

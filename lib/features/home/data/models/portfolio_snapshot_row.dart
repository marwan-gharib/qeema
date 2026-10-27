import 'package:decimal/decimal.dart';
import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/features/home/domain/entities/portfolio_snapshot_entity.dart';

class PortfolioSnapshotRow {
  const PortfolioSnapshotRow({
    required this.snapshotDate,
    required this.totalNominalValue,
    required this.totalRealValue,
  });

  factory PortfolioSnapshotRow.fromJson(Map<String, dynamic> json) {
    return PortfolioSnapshotRow(
      snapshotDate: DateTime.parse(
        json[SupabaseColumns.snapshotDate] as String,
      ),
      totalNominalValue: Decimal.parse(
        (json[SupabaseColumns.totalNominalValue] as num).toString(),
      ),
      totalRealValue: Decimal.parse(
        (json[SupabaseColumns.totalRealValue] as num).toString(),
      ),
    );
  }

  final DateTime snapshotDate;
  final Decimal totalNominalValue;
  final Decimal totalRealValue;

  PortfolioSnapshotEntity toEntity() =>
      PortfolioSnapshotEntity(date: snapshotDate, realTotal: totalRealValue);
}

import 'package:qeema/features/home/data/models/portfolio_snapshot_row.dart';
import 'package:qeema/features/home/domain/entities/portfolio_snapshot_entity.dart';

class PortfolioSnapshotMapper {
  const PortfolioSnapshotMapper._();

  static PortfolioSnapshotEntity fromRow(PortfolioSnapshotRow row) {
    return PortfolioSnapshotEntity(
      date: row.snapshotDate,
      realTotal: row.totalRealValue,
    );
  }
}

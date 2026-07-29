import 'package:qeema/features/home/domain/entities/asset_type_summary_entity.dart';
import 'package:qeema/features/home/domain/entities/portfolio_snapshot_entity.dart';

class DashboardSummaryEntity {
  const DashboardSummaryEntity({
    required this.nominalTotal,
    required this.realTotal,
    required this.assetTypeSummaries,
    required this.trend30Days,
  });

  final double nominalTotal;
  final double realTotal;
  final List<AssetTypeSummaryEntity> assetTypeSummaries;
  final List<PortfolioSnapshotEntity> trend30Days;

  double get erosionPercent {
    if (nominalTotal <= 0) return 0;
    final erosion = ((nominalTotal - realTotal) / nominalTotal) * 100;
    return erosion.clamp(0, 100);
  }

  bool get hasAssets => nominalTotal > 0;
}

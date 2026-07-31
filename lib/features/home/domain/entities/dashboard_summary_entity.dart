import 'package:decimal/decimal.dart';
import 'package:qeema/core/extensions/decimal_extensions.dart';
import 'package:qeema/features/home/domain/entities/asset_type_summary_entity.dart';
import 'package:qeema/features/home/domain/entities/portfolio_snapshot_entity.dart';

class DashboardSummaryEntity {
  const DashboardSummaryEntity({
    required this.nominalTotal,
    required this.realTotal,
    required this.assetTypeSummaries,
    required this.trend30Days,
  });

  final Decimal nominalTotal;
  final Decimal realTotal;
  final List<AssetTypeSummaryEntity> assetTypeSummaries;
  final List<PortfolioSnapshotEntity> trend30Days;

  /// Clamped to [0, 100] at this single source of truth — every consumer
  /// (the erosion ring widget) reads this directly rather than re-deriving
  /// or re-clamping it themselves.
  Decimal get erosionPercent {
    if (nominalTotal <= Decimal.zero) return Decimal.zero;
    final erosion =
        (nominalTotal - realTotal).divideBy(nominalTotal) *
        Decimal.fromInt(100);
    if (erosion < Decimal.zero) return Decimal.zero;
    if (erosion > Decimal.fromInt(100)) return Decimal.fromInt(100);
    return erosion;
  }

  bool get hasAssets => nominalTotal > Decimal.zero;
}

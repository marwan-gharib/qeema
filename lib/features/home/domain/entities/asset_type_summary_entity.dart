import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

const kSignificantMoveThresholdPercent = 2.0;

class AssetTypeSummaryEntity {
  const AssetTypeSummaryEntity({
    required this.assetType,
    required this.currentValue,
    required this.dayChangePercent,
  });

  final AssetType assetType;
  final double currentValue;
  final double dayChangePercent;

  bool get isDayGain => dayChangePercent >= 0;
}

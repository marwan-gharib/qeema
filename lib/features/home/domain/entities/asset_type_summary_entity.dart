import 'package:decimal/decimal.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';

/// Decimal has no const constructors, so this cannot be a `const`.
final kSignificantMoveThresholdPercent = Decimal.parse('2');

class AssetTypeSummaryEntity {
  const AssetTypeSummaryEntity({
    required this.assetType,
    required this.currentValue,
    required this.dayChangePercent,
    required this.hasSufficientPriceHistory,
  });

  final AssetTypeEntity assetType;
  final Decimal currentValue;
  final Decimal dayChangePercent;

  /// False when the type is market-based but fewer than two distinct
  /// price dates exist, keeping "insufficient data" distinguishable from a
  /// genuinely flat day (both render zero, but only the latter is a real 0%).
  final bool hasSufficientPriceHistory;

  bool get isDayGain => dayChangePercent >= Decimal.zero;
}

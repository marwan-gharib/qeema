import 'package:decimal/decimal.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/market_prices/domain/entities/market_price_point_entity.dart';

class MarketPriceSummaryEntity {
  const MarketPriceSummaryEntity({
    required this.assetType,
    required this.todayPrice,
    required this.todayPriceDate,
    required this.fetchedAt,
    required this.weeklyChangePercent,
    required this.sparklinePoints,
  });

  final AssetTypeEntity assetType;
  final Decimal? todayPrice;
  final DateTime? todayPriceDate;
  final DateTime? fetchedAt;
  final Decimal? weeklyChangePercent;
  final List<MarketPricePointEntity> sparklinePoints;

  bool get hasHistory => todayPrice != null && sparklinePoints.length >= 2;

  bool get isGain =>
      weeklyChangePercent != null && weeklyChangePercent! >= Decimal.zero;

  bool get isStale {
    final fetched = fetchedAt;
    if (fetched == null) return false;
    // 36h covers the 6-hour cron cadence with margin for one or two missed
    // runs before flagging the data as stale.
    return DateTime.now().difference(fetched).inHours > 36;
  }
}

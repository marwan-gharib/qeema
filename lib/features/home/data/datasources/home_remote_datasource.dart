import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/utils/asset_type_parsing.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/home/data/models/inflation_rate_row.dart';
import 'package:qeema/features/home/data/models/market_price_row.dart';
import 'package:qeema/features/home/domain/entities/asset_type_summary_entity.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';
import 'package:qeema/features/home/domain/entities/portfolio_snapshot_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRemoteDataSource {
  HomeRemoteDataSource(this._provider);
  final SupabaseClientProvider _provider;

  SupabaseClient get _client => _provider.client;

  Future<DashboardSummaryEntity> getDashboardSummary() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('No authenticated user');
    }

    final results = await Future.wait([
      _client
          .from('assets')
          .select('*, asset_types(code)')
          .eq('user_id', userId)
          .eq('is_deleted', false),
      _client
          .from('market_prices')
          .select('*, asset_types!inner(code)')
          .order('price_date', ascending: false),
      _client.from('inflation_rates').select(),
      _client
          .from('portfolio_snapshots')
          .select()
          .eq('user_id', userId)
          .order('snapshot_date', ascending: true),
    ]);

    final assetsRows = results[0] as List;
    final allPriceRows = (results[1] as List)
        .map((r) => MarketPriceRow.fromJson(r as Map<String, dynamic>))
        .toList();
    final inflationRows = (results[2] as List)
        .map((r) => InflationRateRow.fromJson(r as Map<String, dynamic>))
        .toList();
    final snapshotRows = results[3] as List;

    final priceMap = <AssetType, MarketPriceRow>{};
    final seenTypes = <AssetType>{};
    for (final row in allPriceRows) {
      if (seenTypes.add(row.assetType)) {
        priceMap[row.assetType] = row;
      }
    }

    double nominalTotal = 0;
    double realTotal = 0;
    final nominalByType = <AssetType, double>{
      for (final t in AssetType.values) t: 0,
    };

    for (final row in assetsRows) {
      final map = row as Map<String, dynamic>;
      final typeData = map['asset_types'] as Map<String, dynamic>?;
      final code = typeData?['code'] as String? ?? '';
      final type = assetTypeFromString(code);
      final amount = (map['amount'] as num).toDouble();
      final entryDate = DateTime.parse(map['entry_date'] as String);
      final currentPrice = priceMap[type]?.price ?? 0;

      final assetNominal = amount * currentPrice;
      nominalTotal += assetNominal;
      nominalByType[type] = (nominalByType[type] ?? 0) + assetNominal;

      final factor = _cumulativeInflationFactor(entryDate, inflationRows);
      realTotal += factor == 0 ? assetNominal : assetNominal / factor;
    }

    final summaries = AssetType.values.map((type) {
      final priceRow = priceMap[type];
      final change = (priceRow == null || priceRow.previousPrice == 0)
          ? 0.0
          : ((priceRow.price - priceRow.previousPrice) /
                    priceRow.previousPrice) *
                100;
      return AssetTypeSummaryEntity(
        assetType: type,
        currentValue: nominalByType[type] ?? 0,
        dayChangePercent: change,
      );
    }).toList();

    // In production this table would be populated by a daily scheduled
    // Edge Function. For this portfolio build it is seeded manually.
    final trend = snapshotRows.map((row) {
      final map = row as Map<String, dynamic>;
      return PortfolioSnapshotEntity(
        date: DateTime.parse(map['snapshot_date'] as String),
        realTotal: (map['total_real_value'] as num).toDouble(),
      );
    }).toList();

    return DashboardSummaryEntity(
      nominalTotal: nominalTotal,
      realTotal: realTotal,
      assetTypeSummaries: summaries,
      trend30Days: trend,
    );
  }

  // If entry_date is older than the oldest seeded month, only the months
  // that exist in the table are compounded — no extrapolation.
  double _cumulativeInflationFactor(
    DateTime entryDate,
    List<InflationRateRow> rows,
  ) {
    final now = DateTime.now();
    double factor = 1.0;
    for (final r in rows) {
      final rowDate = DateTime(r.year, r.month);
      final entryMonth = DateTime(entryDate.year, entryDate.month);
      final currentMonth = DateTime(now.year, now.month);
      final isWithinRange =
          !rowDate.isBefore(entryMonth) && !rowDate.isAfter(currentMonth);
      if (isWithinRange) {
        factor *= (1 + r.monthlyRatePercent / 100);
      }
    }
    return factor;
  }
}

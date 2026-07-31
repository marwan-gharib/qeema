import 'package:qeema/core/constants/supabase_tables.dart';
import 'package:qeema/core/network/supabase_query_executor.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/home/data/models/inflation_rate_row.dart';
import 'package:qeema/features/home/data/models/market_price_row.dart';
import 'package:qeema/features/home/data/models/portfolio_snapshot_row.dart';

class HomeRemoteDataSource {
  const HomeRemoteDataSource(this._queryExecutor);

  final SupabaseQueryExecutor _queryExecutor;

  Future<ApiResult<List<MarketPriceRow>>> getMarketPrices() {
    return _queryExecutor.run((client) async {
      final response = await client
          .from(SupabaseTables.marketPrices)
          .select('*, asset_types(code)')
          .order('price_date', ascending: false);
      return (response as List)
          .map((r) => MarketPriceRow.fromJson(r as Map<String, dynamic>))
          .toList();
    });
  }

  Future<ApiResult<List<InflationRateRow>>> getInflationRates() {
    return _queryExecutor.run((client) async {
      final response = await client
          .from(SupabaseTables.inflationRates)
          .select();
      return (response as List)
          .map((r) => InflationRateRow.fromJson(r as Map<String, dynamic>))
          .toList();
    });
  }

  // In production this table would be populated by a daily scheduled job.
  // For this portfolio build it is seeded manually.
  Future<ApiResult<List<PortfolioSnapshotRow>>> getPortfolioSnapshots() {
    return _queryExecutor.run((client) async {
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('No authenticated user');
      }
      final response = await client
          .from(SupabaseTables.portfolioSnapshots)
          .select()
          .eq('user_id', userId)
          .order('snapshot_date', ascending: true);
      return (response as List)
          .map((r) => PortfolioSnapshotRow.fromJson(r as Map<String, dynamic>))
          .toList();
    });
  }
}

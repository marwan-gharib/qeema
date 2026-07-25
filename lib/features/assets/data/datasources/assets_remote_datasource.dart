import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/features/assets/data/models/asset_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssetsRemoteDataSource {
  AssetsRemoteDataSource(this._provider);
  final SupabaseClientProvider _provider;

  SupabaseClient get _client => _provider.client;

  Future<List<AssetModel>> getAssets() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('No authenticated user');
    }

    final assetsResponse = await _client
        .from('assets')
        .select('*, asset_types(code, name, base_unit)')
        .eq('user_id', userId)
        .eq('is_deleted', false)
        .order('entry_date', ascending: false);

    final pricesResponse = await _client
        .from('market_prices')
        .select('*, asset_types!inner(code)')
        .order('price_date', ascending: false);

    final priceMap = <String, double>{};
    final seenTypes = <String>{};
    for (final row in pricesResponse as List) {
      final typeData =
          (row as Map<String, dynamic>)['asset_types'] as Map<String, dynamic>?;
      final code = typeData?['code'] as String?;
      if (code != null && seenTypes.add(code)) {
        priceMap[code] = (row['price'] as num).toDouble();
      }
    }

    return (assetsResponse as List).map((row) {
      final rowMap = row as Map<String, dynamic>;
      final typeData = rowMap['asset_types'] as Map<String, dynamic>?;
      final code = typeData?['code'] as String? ?? '';
      return AssetModel.fromJson(rowMap, currentPrice: priceMap[code]);
    }).toList();
  }
}

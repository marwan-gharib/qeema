import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssetsRemoteDataSource {
  AssetsRemoteDataSource(this._provider);
  final SupabaseClientProvider _provider;

  SupabaseClient get _client => _provider.client;

  Future<List<AssetModelFromServer>> getAssets() async {
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
      return AssetModelFromServer.fromJson(
        rowMap,
        currentPrice: priceMap[code],
      );
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAssetTypes() async {
    final response = await _client
        .from('asset_types')
        .select('id, code, name, is_market_based, base_unit')
        .eq('is_active', true)
        .order('code');

    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> addAsset(Map<String, dynamic> assetData) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('No authenticated user');
    }

    final response = await _client.from('assets').insert({
      'user_id': userId,
      ...assetData,
    }).select();

    final rows = response as List;
    if (rows.isEmpty) throw Exception('Failed to insert asset');
    return rows.first as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateAsset(
    String assetId,
    Map<String, dynamic> data,
  ) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('No authenticated user');

    final response = await _client
        .from('assets')
        .update(data)
        .eq('id', assetId)
        .eq('user_id', userId)
        .select();

    final rows = response as List;
    if (rows.isEmpty) throw Exception('Asset not found or not owned by user');
    return rows.first as Map<String, dynamic>;
  }

  Future<void> softDeleteAsset(String assetId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('No authenticated user');

    await _client
        .from('assets')
        .update({
          'is_deleted': true,
          'deleted_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', assetId)
        .eq('user_id', userId);
  }

  Future<List<Map<String, dynamic>>> getAssetHistory(String assetId) async {
    final response = await _client
        .from('asset_history')
        .select()
        .eq('asset_id', assetId)
        .order('changed_at', ascending: false);

    return (response as List).cast<Map<String, dynamic>>();
  }
}

class AssetModelFromServer {
  AssetModelFromServer({
    required this.id,
    required this.assetTypeCode,
    required this.amount,
    required this.priceAtEntry,
    required this.entryDate,
    this.note,
    this.currentPrice,
  });

  factory AssetModelFromServer.fromJson(
    Map<String, dynamic> json, {
    double? currentPrice,
  }) {
    final typeData = json['asset_types'] as Map<String, dynamic>?;
    final typeCode = typeData?['code'] as String? ?? '';
    return AssetModelFromServer(
      id: json['id'] as String,
      assetTypeCode: typeCode,
      amount: (json['amount'] as num).toDouble(),
      priceAtEntry: (json['price_at_entry'] as num).toDouble(),
      entryDate: DateTime.parse(json['entry_date'] as String),
      note: json['note'] as String?,
      currentPrice: currentPrice,
    );
  }

  final String id;
  final String assetTypeCode;
  final double amount;
  final double priceAtEntry;
  final DateTime entryDate;
  final String? note;
  final double? currentPrice;
}

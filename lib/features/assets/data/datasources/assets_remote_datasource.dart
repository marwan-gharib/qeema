import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/core/constants/supabase_tables.dart';
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
        .from(SupabaseTables.assets)
        .select(
          '*, ${SupabaseTables.assetTypes}(${SupabaseColumns.code}, '
          '${SupabaseColumns.name}, ${SupabaseColumns.baseUnit})',
        )
        .eq(SupabaseColumns.userId, userId)
        .eq(SupabaseColumns.isDeleted, false)
        .order(SupabaseColumns.entryDate, ascending: false);

    final pricesResponse = await _client
        .from(SupabaseTables.marketPrices)
        .select(
          '*, ${SupabaseTables.assetTypes}!inner(${SupabaseColumns.code})',
        )
        .order(SupabaseColumns.priceDate, ascending: false);

    final priceMap = <String, double>{};
    final seenTypes = <String>{};
    for (final row in pricesResponse as List) {
      final typeData =
          (row as Map<String, dynamic>)[SupabaseTables.assetTypes]
              as Map<String, dynamic>?;
      final code = typeData?[SupabaseColumns.code] as String?;
      if (code != null && seenTypes.add(code)) {
        priceMap[code] = (row[SupabaseColumns.price] as num).toDouble();
      }
    }

    return (assetsResponse as List).map((row) {
      final rowMap = row as Map<String, dynamic>;
      final typeData =
          rowMap[SupabaseTables.assetTypes] as Map<String, dynamic>?;
      final code = typeData?[SupabaseColumns.code] as String? ?? '';
      return AssetModelFromServer.fromJson(
        rowMap,
        currentPrice: priceMap[code],
      );
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAssetTypes() async {
    final response = await _client
        .from(SupabaseTables.assetTypes)
        .select(
          '${SupabaseColumns.id}, ${SupabaseColumns.code}, '
          '${SupabaseColumns.name}, ${SupabaseColumns.isMarketBased}, '
          '${SupabaseColumns.baseUnit}',
        )
        .eq(SupabaseColumns.isActive, true)
        .order(SupabaseColumns.code);

    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> addAsset(Map<String, dynamic> assetData) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('No authenticated user');
    }

    final response = await _client.from(SupabaseTables.assets).insert({
      SupabaseColumns.userId: userId,
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
        .from(SupabaseTables.assets)
        .update(data)
        .eq(SupabaseColumns.id, assetId)
        .eq(SupabaseColumns.userId, userId)
        .select();

    final rows = response as List;
    if (rows.isEmpty) throw Exception('Asset not found or not owned by user');
    return rows.first as Map<String, dynamic>;
  }

  Future<void> softDeleteAsset(String assetId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('No authenticated user');

    await _client
        .from(SupabaseTables.assets)
        .update({
          SupabaseColumns.isDeleted: true,
          SupabaseColumns.deletedAt: DateTime.now().toUtc().toIso8601String(),
        })
        .eq(SupabaseColumns.id, assetId)
        .eq(SupabaseColumns.userId, userId);
  }

  Future<List<Map<String, dynamic>>> getAssetHistory(String assetId) async {
    final response = await _client
        .from(SupabaseTables.assetHistory)
        .select()
        .eq(SupabaseColumns.assetId, assetId)
        .order(SupabaseColumns.changedAt, ascending: false);

    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getPriceHistory(
    String assetTypeCode,
  ) async {
    final response = await _client
        .from(SupabaseTables.marketPrices)
        .select(
          '*, ${SupabaseTables.assetTypes}!inner(${SupabaseColumns.code})',
        )
        .eq(
          '${SupabaseTables.assetTypes}.${SupabaseColumns.code}',
          assetTypeCode,
        )
        .order(SupabaseColumns.priceDate, ascending: true);

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
    final typeData = json[SupabaseTables.assetTypes] as Map<String, dynamic>?;
    final typeCode = typeData?[SupabaseColumns.code] as String? ?? '';
    return AssetModelFromServer(
      id: json[SupabaseColumns.id] as String,
      assetTypeCode: typeCode,
      amount: (json[SupabaseColumns.amount] as num).toDouble(),
      priceAtEntry: (json[SupabaseColumns.priceAtEntry] as num).toDouble(),
      entryDate: DateTime.parse(json[SupabaseColumns.entryDate] as String),
      note: json[SupabaseColumns.note] as String?,
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

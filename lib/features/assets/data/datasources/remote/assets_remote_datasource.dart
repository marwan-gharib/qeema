import 'package:qeema/core/network/supabase_query_executor.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/data/models/asset_model.dart';
import 'package:qeema/features/assets/data/models/asset_type_model.dart';

class AssetsRemoteDataSource {
  const AssetsRemoteDataSource(this._queryExecutor);
  final SupabaseQueryExecutor _queryExecutor;

  Future<ApiResult<List<AssetModel>>> fetchAssets(String userId) async {
    return _queryExecutor.run((client) async {
      final data = await client
          .from('assets')
          .select()
          .eq('user_id', userId)
          .eq('is_deleted', false)
          .order('created_at', ascending: false);
      return (data as List)
          .map((e) => AssetModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  Future<ApiResult<List<AssetTypeModel>>> fetchAssetTypes() async {
    return _queryExecutor.run((client) async {
      final data = await client
          .from('asset_types')
          .select()
          .eq('is_active', true)
          .order('code');
      return (data as List)
          .map((e) => AssetTypeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }

  Future<ApiResult<AssetModel>> createAsset({
    required String userId,
    required String assetTypeId,
    required String amount,
    required String priceAtEntry,
    required DateTime entryDate,
    String? note,
  }) async {
    return _queryExecutor.run((client) async {
      final data = await client
          .from('assets')
          .insert({
            'user_id': userId,
            'asset_type_id': assetTypeId,
            'amount': amount,
            'price_at_entry': priceAtEntry,
            'entry_date': entryDate.toIso8601String().split('T').first,
            'note': note,
          })
          .select()
          .single();
      return AssetModel.fromJson(data);
    });
  }

  Future<ApiResult<AssetModel>> updateAsset({
    required String id,
    required String amount,
    required String priceAtEntry,
    String? note,
  }) async {
    return _queryExecutor.run((client) async {
      final data = await client
          .from('assets')
          .update({
            'amount': amount,
            'price_at_entry': priceAtEntry,
            'note': note,
          })
          .eq('id', id)
          .select()
          .single();
      return AssetModel.fromJson(data);
    });
  }

  Future<ApiResult<void>> deleteAsset(String assetId) async {
    return _queryExecutor.run((client) async {
      await client
          .from('assets')
          .update({
            'is_deleted': true,
            'deleted_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', assetId);
    });
  }

  Future<ApiResult<List<AssetModel>>> fetchAssetHistory(String assetId) async {
    return _queryExecutor.run((client) async {
      final data = await client
          .from('asset_history')
          .select()
          .eq('asset_id', assetId)
          .order('changed_at', ascending: false);
      return (data as List)
          .map((e) => AssetModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }
}

import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/local/cache/daos/assets_dao.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/data/datasources/assets_remote_datasource.dart';
import 'package:qeema/features/assets/data/models/market_price_model.dart';
import 'package:qeema/features/assets/data/repositories/assets_repository_impl_support.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssetsRepositoryImpl
    with AssetsRepositoryImplSupport
    implements AssetsRepository {
  AssetsRepositoryImpl(this._remoteDataSource, this._assetsDao);

  final AssetsRemoteDataSource _remoteDataSource;
  final AssetsDao _assetsDao;

  @override
  AssetsRemoteDataSource get remoteDataSource => _remoteDataSource;

  @override
  AssetsDao get assetsDao => _assetsDao;

  @override
  Future<ApiResult<List<AssetEntity>>> getAssets() async {
    try {
      final models = await _remoteDataSource.getAssets();
      return Success(models.map((model) => model.toEntity()).toList());
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabaseError(e, AssetOperation.read));
    } catch (e) {
      return const ResultFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<List<AssetTypeEntity>>> getAssetTypes() async {
    try {
      final rows = await _remoteDataSource.getAssetTypes();
      final types = rows.map((row) {
        return AssetTypeEntity(
          id: row[SupabaseColumns.id] as String,
          code: row[SupabaseColumns.code] as String,
          name: row[SupabaseColumns.name] as String,
          isMarketBased: row[SupabaseColumns.isMarketBased] as bool,
          baseUnit: row[SupabaseColumns.baseUnit] as String,
        );
      }).toList();
      return Success(types);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabaseError(e, AssetOperation.read));
    } catch (e) {
      return const ResultFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<AssetEntity>> addAsset(AddAssetParams params) {
    return addAssetWithSupport(params);
  }

  @override
  Future<ApiResult<AssetEntity>> updateAsset(UpdateAssetParams params) {
    return updateAssetWithSupport(params);
  }

  @override
  Future<ApiResult<void>> softDeleteAsset(String assetId) {
    return softDeleteAssetWithSupport(assetId);
  }

  @override
  Future<ApiResult<List<AssetHistoryEntryEntity>>> getAssetHistory(
    String assetId,
  ) {
    return getAssetHistoryWithSupport(assetId);
  }

  @override
  Future<ApiResult<List<MarketPriceEntity>>> getPriceHistory(
    String assetTypeCode,
  ) async {
    try {
      final rows = await _remoteDataSource.getPriceHistory(assetTypeCode);
      return Success(
        rows.map(MarketPriceModel.fromRow).map((m) => m.toEntity()).toList(),
      );
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabaseError(e, AssetOperation.read));
    } catch (e) {
      return const ResultFailure(UnknownFailure());
    }
  }
}

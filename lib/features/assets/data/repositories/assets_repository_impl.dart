import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/core/error/failure_mapper.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/local/cache/daos/assets_dao.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/data/datasources/assets_remote_datasource.dart';
import 'package:qeema/features/assets/data/models/market_price_model.dart';
import 'package:qeema/features/assets/data/models/row_parsing.dart';
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
    // Cache-first: the mirror answers instantly and works offline; the network
    // is only the fallback for an empty cache.
    final cached = await cachedAssets();
    if (cached.isNotEmpty) return Success(cached);
    return refreshAssets();
  }

  @override
  Future<ApiResult<List<AssetEntity>>> refreshAssets() async {
    Object? networkError;
    try {
      final models = await _remoteDataSource.getAssets();
      final entities = models.map((model) => model.toEntity()).toList();
      await mirrorAssetsToCache(models);
      return Success(entities);
    } on PostgrestException catch (e) {
      networkError = e;
    } catch (e) {
      networkError = e;
    }

    // Offline fallback: a stale mirror beats an error when the cache has data.
    final cached = await cachedAssets();
    if (cached.isNotEmpty) return Success(cached);
    if (networkError is PostgrestException) {
      return ResultFailure(
        mapExceptionToFailure(
          networkError,
          assetOperation: AssetOperation.read,
        ),
      );
    }
    return const ResultFailure(UnknownFailure());
  }

  @override
  Future<ApiResult<List<AssetTypeEntity>>> getAssetTypes() async {
    try {
      final rows = await _remoteDataSource.getAssetTypes();
      final types = rows.map((row) {
        return AssetTypeEntity(
          id: requiredString(row, SupabaseColumns.id),
          code: requiredString(row, SupabaseColumns.code),
          name: requiredString(row, SupabaseColumns.name),
          isMarketBased: requiredBool(row, SupabaseColumns.isMarketBased),
          baseUnit: requiredString(row, SupabaseColumns.baseUnit),
        );
      }).toList();
      return Success(types);
    } on PostgrestException catch (e) {
      return ResultFailure(
        mapExceptionToFailure(e, assetOperation: AssetOperation.read),
      );
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
      return ResultFailure(
        mapExceptionToFailure(e, assetOperation: AssetOperation.read),
      );
    } catch (e) {
      return const ResultFailure(UnknownFailure());
    }
  }
}

import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/local/cache/daos/assets_dao.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/data/datasources/assets_remote_datasource.dart';
import 'package:qeema/features/assets/data/mappers/market_price_mapper.dart';
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
      return Success(toEntities(models));
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabaseError(e));
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
          id: row['id'] as String,
          code: row['code'] as String,
          name: row['name'] as String,
          isMarketBased: row['is_market_based'] as bool,
          baseUnit: row['base_unit'] as String,
        );
      }).toList();
      return Success(types);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabaseError(e));
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
      return Success(rows.map(MarketPriceMapper.fromRow).toList());
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabaseError(e));
    } catch (e) {
      return const ResultFailure(UnknownFailure());
    }
  }
}

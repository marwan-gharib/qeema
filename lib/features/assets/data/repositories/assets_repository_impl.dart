import 'package:drift/drift.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/network/network_info.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/data/datasources/local/assets_local_datasource.dart';
import 'package:qeema/features/assets/data/datasources/remote/assets_remote_datasource.dart';
import 'package:qeema/features/assets/data/mappers/asset_mapper.dart';
import 'package:qeema/features/assets/data/models/asset_model.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';

class AssetsRepositoryImpl implements AssetsRepository {
  AssetsRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._mapper,
    this._networkInfo,
    this._clientProvider,
  );

  final AssetsRemoteDataSource _remoteDataSource;
  final AssetsLocalDataSource _localDataSource;
  final AssetMapper _mapper;
  final NetworkInfo _networkInfo;
  final SupabaseClientProvider _clientProvider;

  String? get _userId => _clientProvider.client.auth.currentUser?.id;

  @override
  Stream<ApiResult<List<AssetEntity>>> watchAssets() {
    final userId = _userId;
    if (userId == null) {
      return Stream.value(
        const ResultFailure(AuthFailure('Not authenticated')),
      );
    }

    return _localDataSource.watchAssets(userId).map((cachedList) {
      final entities = cachedList.map(_mapper.fromCached).toList();
      return Success<List<AssetEntity>>(entities);
    });
  }

  @override
  Future<ApiResult<List<AssetTypeEntity>>> getAssetTypes() async {
    final result = await _remoteDataSource.fetchAssetTypes();
    return result.fold(
      onSuccess: (types) {
        final entities = types.map((m) => m.toEntity()).toList();
        _localDataSource.cacheAssetTypes(types);
        return Success(entities);
      },
      onFailure: (f) async {
        final cached = await _localDataSource.getCachedAssetTypes();
        if (cached.isNotEmpty) {
          return Success(cached.map(_mapper.assetTypeFromCached).toList());
        }
        return ResultFailure(f);
      },
    );
  }

  @override
  Future<ApiResult<AssetEntity>> addAsset(AddAssetParams params) async {
    final userId = _userId;
    if (userId == null) {
      return const ResultFailure(AuthFailure('Not authenticated'));
    }

    final now = DateTime.now();
    final id = '${now.millisecondsSinceEpoch}_$userId';

    final pendingEntry = CachedAssetsTableCompanion.insert(
      id: id,
      userId: userId,
      assetTypeCode: params.assetTypeCode,
      assetTypeId: params.assetTypeId,
      amount: params.amount.toString(),
      priceAtEntry: params.priceAtEntry.toString(),
      currentUnitPrice: params.priceAtEntry.toString(),
      entryDate: params.entryDate,
      note: Value<String?>(params.note),
      pendingSync: const Value(true),
      createdAt: now,
      updatedAt: now,
    );
    await _localDataSource.insertOrUpdateAsset(pendingEntry);

    final isConnected = await _networkInfo.isConnected;
    if (isConnected) {
      return _pushAssetAndSync(id, userId, params, now);
    }

    return Success(
      AssetEntity(
        id: id,
        assetTypeId: params.assetTypeId,
        assetTypeCode: params.assetTypeCode,
        amount: params.amount,
        priceAtEntry: params.priceAtEntry,
        entryDate: params.entryDate,
        note: params.note,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<ApiResult<AssetEntity>> _pushAssetAndSync(
    String id,
    String userId,
    AddAssetParams params,
    DateTime now,
  ) async {
    final result = await _remoteDataSource.createAsset(
      userId: userId,
      assetTypeId: params.assetTypeId,
      amount: params.amount.toString(),
      priceAtEntry: params.priceAtEntry.toString(),
      entryDate: params.entryDate,
      note: params.note,
    );

    return result.fold(
      onSuccess: (model) async {
        await _localDataSource.insertOrUpdateAsset(
          CachedAssetsTableCompanion(
            id: Value(id),
            userId: Value(userId),
            assetTypeCode: Value(params.assetTypeCode),
            assetTypeId: Value(params.assetTypeId),
            amount: Value(params.amount.toString()),
            priceAtEntry: Value(params.priceAtEntry.toString()),
            currentUnitPrice: Value(model.priceAtEntry.toString()),
            entryDate: Value(params.entryDate),
            note: Value<String?>(params.note),
            pendingSync: const Value(false),
            lastSyncedAt: Value(DateTime.now()),
            createdAt: Value(model.createdAt),
            updatedAt: Value(model.updatedAt),
          ),
        );
        return Success(
          AssetModel(
            id: model.id,
            assetTypeId: model.assetTypeId,
            assetTypeCode: model.assetTypeCode,
            amount: model.amount,
            priceAtEntry: model.priceAtEntry,
            entryDate: model.entryDate,
            note: model.note,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt,
          ).toEntity(),
        );
      },
      onFailure: (f) async {
        await _localDataSource.markPendingSync(id);
        return ResultFailure(f);
      },
    );
  }

  @override
  Future<ApiResult<AssetEntity>> updateAsset(UpdateAssetParams params) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      return const ResultFailure(NetworkFailure('No internet connection'));
    }

    final result = await _remoteDataSource.updateAsset(
      id: params.id,
      amount: params.amount.toString(),
      priceAtEntry: params.priceAtEntry.toString(),
      note: params.note,
    );

    return result.fold(
      onSuccess: (model) async {
        await _localDataSource.insertOrUpdateAsset(
          CachedAssetsTableCompanion(
            id: Value(params.id),
            amount: Value(params.amount.toString()),
            priceAtEntry: Value(params.priceAtEntry.toString()),
            note: Value<String?>(params.note),
            pendingSync: const Value(false),
            lastSyncedAt: Value(DateTime.now()),
            updatedAt: Value(model.updatedAt),
          ),
        );
        return Success(model.toEntity());
      },
      onFailure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<ApiResult<void>> softDeleteAsset(String assetId) async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      return const ResultFailure(NetworkFailure('No internet connection'));
    }

    final result = await _remoteDataSource.deleteAsset(assetId);
    return result.fold(
      onSuccess: (_) async {
        await _localDataSource.deleteAsset(assetId);
        return const Success(null);
      },
      onFailure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<ApiResult<List<AssetHistoryEntryEntity>>> getAssetHistory(
    String assetId,
  ) async {
    final cached = await _localDataSource.getCachedHistory(assetId);
    if (cached.isNotEmpty) {
      return Success(cached.map(_mapper.historyFromCached).toList());
    }
    final result = await _remoteDataSource.fetchAssetHistory(assetId);
    return result.fold(
      onSuccess: (models) {
        _localDataSource.cacheHistory(assetId, models);
        return Success(
          models
              .map(
                (m) => AssetHistoryEntryEntity(
                  id: m.id,
                  assetId: assetId,
                  changeType: 'updated',
                  changedAt: m.updatedAt,
                ),
              )
              .toList(),
        );
      },
      onFailure: (f) => ResultFailure(f),
    );
  }
}

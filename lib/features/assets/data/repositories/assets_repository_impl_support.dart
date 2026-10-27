import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' show Value;
import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/core/constants/supabase_tables.dart';
import 'package:qeema/core/error/failure_mapper.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/local/cache/daos/assets_dao.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/asset_type_parsing.dart';
import 'package:qeema/core/utils/logger.dart';
import 'package:qeema/features/assets/data/datasources/assets_remote_datasource.dart';
import 'package:qeema/features/assets/data/models/asset_history_model.dart';
import 'package:qeema/features/assets/data/models/asset_model_from_server.dart';
import 'package:qeema/features/assets/data/models/cached_asset_model.dart';
import 'package:qeema/features/assets/data/models/row_parsing.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin AssetsRepositoryImplSupport {
  AssetsRemoteDataSource get remoteDataSource;
  AssetsDao get assetsDao;

  /// Reads the cached mirror. A broken cache read is logged and answered with
  /// an empty list (the network path stays usable); unparsable rows are
  /// skipped instead of showing a fabricated amount.
  Future<List<AssetEntity>> cachedAssets() async {
    try {
      final rows = await assetsDao.getActiveAssets(
        AppConstants.localCacheUserId,
      );
      final entities = rows
          .map((row) => row.tryToEntity())
          .whereType<AssetEntity>()
          .toList();
      if (entities.length < rows.length) {
        Logger.warning(
          'assets cache: skipped ${rows.length - entities.length} malformed row(s)',
        );
      }
      return entities;
    } catch (e) {
      Logger.warning('assets cache read failed: $e');
      return const [];
    }
  }

  /// Rewrites the cached mirror to exactly [models] after a successful fetch.
  /// A cache failure is logged, never surfaced: the server already answered.
  Future<void> mirrorAssetsToCache(List<AssetModelFromServer> models) async {
    try {
      await assetsDao.replaceAll(
        models.map((model) => model.toCacheCompanion()).toList(),
      );
    } catch (e) {
      Logger.warning('assets cache mirror failed: $e');
    }
  }

  /// Cache write after a successful remote call. The server state wins, so a
  /// cache failure is logged, never turned into a user-facing failure.
  Future<void> _mirrorToCache(CachedAssetsTableCompanion entry) async {
    try {
      await assetsDao.insertOrUpdate(entry);
    } catch (e) {
      Logger.warning('assets cache write failed: $e');
    }
  }

  Future<ApiResult<AssetEntity>> addAssetWithSupport(
    AddAssetParams params,
  ) async {
    if (params.amount <= Decimal.zero) {
      return const ResultFailure(InvalidAssetAmountFailure());
    }

    try {
      final typeRows = await remoteDataSource.getAssetTypes();
      final typeRow = typeRows.firstWhere(
        (r) => r[SupabaseColumns.id] == params.assetTypeId,
      );
      final isMarketBased = requiredBool(
        typeRow,
        SupabaseColumns.isMarketBased,
      );
      final typeCode = requiredString(typeRow, SupabaseColumns.code);

      if (isMarketBased && params.priceAtEntry == null) {
        return const ResultFailure(PriceRequiredFailure());
      }

      final priceAtEntry = (params.priceAtEntry ?? Decimal.one).toDouble();
      final amountDouble = params.amount.toDouble();
      final now = DateTime.now();
      final entryDateStr =
          '${params.entryDate.year.toString().padLeft(4, '0')}-${params.entryDate.month.toString().padLeft(2, '0')}-${params.entryDate.day.toString().padLeft(2, '0')}';

      final result = await remoteDataSource.addAsset({
        SupabaseColumns.assetTypeId: params.assetTypeId,
        SupabaseColumns.amount: amountDouble,
        SupabaseColumns.priceAtEntry: priceAtEntry,
        SupabaseColumns.entryDate: entryDateStr,
        if (params.note != null) SupabaseColumns.note: params.note,
      });

      final serverId = requiredString(result, SupabaseColumns.id);
      final serverAmount = requiredNum(
        result,
        SupabaseColumns.amount,
      ).toDouble();
      final serverPrice = requiredNum(
        result,
        SupabaseColumns.priceAtEntry,
      ).toDouble();
      final serverEntryDate = requiredDate(result, SupabaseColumns.entryDate);
      final serverNote = optionalString(result, SupabaseColumns.note);

      await _mirrorToCache(
        CachedAssetsTableCompanion(
          id: Value(serverId),
          userId: const Value(AppConstants.localCacheUserId),
          assetTypeCode: Value(typeCode),
          assetTypeId: Value(params.assetTypeId),
          amount: Value(serverAmount.toString()),
          priceAtEntry: Value(serverPrice.toString()),
          currentUnitPrice: const Value(''),
          entryDate: Value(serverEntryDate),
          note: Value(serverNote),
          pendingSync: const Value(false),
          createdAt: Value(now),
          updatedAt: Value(now),
          lastSyncedAt: Value(now),
        ),
      );

      return Success(
        AssetEntity(
          id: serverId,
          assetType: assetTypeFromString(typeCode),
          amount: serverAmount,
          priceAtEntry: serverPrice,
          entryDate: serverEntryDate,
          note: serverNote,
        ),
      );
    } on PostgrestException catch (e) {
      return ResultFailure(
        mapExceptionToFailure(e, assetOperation: AssetOperation.add),
      );
    } catch (e) {
      return ResultFailure(AssetOperationFailure(AssetOperation.add, '$e'));
    }
  }

  Future<ApiResult<AssetEntity>> updateAssetWithSupport(
    UpdateAssetParams params,
  ) async {
    if (params.amount <= Decimal.zero) {
      return const ResultFailure(InvalidAssetAmountFailure());
    }

    final priceAtEntry = (params.priceAtEntry ?? Decimal.one).toDouble();
    final amountDouble = params.amount.toDouble();
    final now = DateTime.now();
    final entryDateStr =
        '${params.entryDate.year.toString().padLeft(4, '0')}-${params.entryDate.month.toString().padLeft(2, '0')}-${params.entryDate.day.toString().padLeft(2, '0')}';

    try {
      final result = await remoteDataSource.updateAsset(params.assetId, {
        SupabaseColumns.amount: amountDouble,
        SupabaseColumns.priceAtEntry: priceAtEntry,
        SupabaseColumns.entryDate: entryDateStr,
        if (params.note != null) SupabaseColumns.note: params.note,
      });

      final serverAmount = requiredNum(
        result,
        SupabaseColumns.amount,
      ).toDouble();
      final serverPrice = requiredNum(
        result,
        SupabaseColumns.priceAtEntry,
      ).toDouble();
      final serverEntryDate = requiredDate(result, SupabaseColumns.entryDate);
      final serverNote = optionalString(result, SupabaseColumns.note);

      await _mirrorToCache(
        CachedAssetsTableCompanion(
          id: Value(params.assetId),
          amount: Value(serverAmount.toString()),
          priceAtEntry: Value(serverPrice.toString()),
          entryDate: Value(serverEntryDate),
          note: Value(serverNote),
          pendingSync: const Value(false),
          updatedAt: Value(now),
          lastSyncedAt: Value(now),
        ),
      );

      return Success(
        AssetEntity(
          id: params.assetId,
          assetType: assetTypeFromString(_updateTypeCode(result)),
          amount: serverAmount,
          priceAtEntry: serverPrice,
          entryDate: serverEntryDate,
          note: serverNote,
        ),
      );
    } on PostgrestException catch (e) {
      return ResultFailure(
        mapExceptionToFailure(e, assetOperation: AssetOperation.update),
      );
    } catch (e) {
      return ResultFailure(AssetOperationFailure(AssetOperation.update, '$e'));
    }
  }

  Future<ApiResult<void>> softDeleteAssetWithSupport(String assetId) async {
    try {
      await remoteDataSource.softDeleteAsset(assetId);
    } on PostgrestException catch (e) {
      return ResultFailure(
        mapExceptionToFailure(e, assetOperation: AssetOperation.delete),
      );
    } catch (e) {
      return ResultFailure(AssetOperationFailure(AssetOperation.delete, '$e'));
    }

    // The server accepted the delete; the cache row is dropped best-effort.
    try {
      await assetsDao.deleteById(assetId);
    } catch (e) {
      Logger.warning('assets cache delete failed: $e');
    }
    return const Success(null);
  }

  Future<ApiResult<List<AssetHistoryEntryEntity>>> getAssetHistoryWithSupport(
    String assetId,
  ) async {
    try {
      final rows = await remoteDataSource.getAssetHistory(assetId);
      final entries = rows
          .map(AssetHistoryModel.fromRow)
          .map((model) => model.toEntity())
          .toList();
      return Success(entries);
    } on PostgrestException catch (e) {
      return ResultFailure(
        mapExceptionToFailure(e, assetOperation: AssetOperation.loadHistory),
      );
    } catch (e) {
      return ResultFailure(
        AssetOperationFailure(AssetOperation.loadHistory, '$e'),
      );
    }
  }
}

/// Reads the joined asset_types code from an update response. A missing join
/// or code yields '' (the parser's lenient path); a non-String code is malformed.
String _updateTypeCode(Map<String, dynamic> result) {
  final typeData = result[SupabaseTables.assetTypes];
  if (typeData is! Map) return '';
  final codeValue = typeData[SupabaseColumns.code];
  if (codeValue == null) return '';
  return codeValue is String
      ? codeValue
      : malformed(SupabaseColumns.code, codeValue);
}

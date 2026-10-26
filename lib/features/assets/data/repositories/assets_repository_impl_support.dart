import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/core/constants/supabase_tables.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/local/cache/daos/assets_dao.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/asset_type_parsing.dart';
import 'package:qeema/features/assets/data/datasources/assets_remote_datasource.dart';
import 'package:qeema/features/assets/data/models/asset_history_model.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin AssetsRepositoryImplSupport {
  AssetsRemoteDataSource get remoteDataSource;
  AssetsDao get assetsDao;

  static final _random = math.Random();

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
      final isMarketBased = typeRow[SupabaseColumns.isMarketBased] as bool;
      final typeCode = typeRow[SupabaseColumns.code] as String;

      if (isMarketBased && params.priceAtEntry == null) {
        return const ResultFailure(PriceRequiredFailure());
      }

      final priceAtEntry = (params.priceAtEntry ?? Decimal.one).toDouble();
      final amountDouble = params.amount.toDouble();
      final localId =
          'local_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(99999)}';
      final now = DateTime.now();
      final entryDateStr =
          '${params.entryDate.year.toString().padLeft(4, '0')}-${params.entryDate.month.toString().padLeft(2, '0')}-${params.entryDate.day.toString().padLeft(2, '0')}';

      try {
        await assetsDao.insertOrUpdate(
          CachedAssetsTableCompanion(
            id: Value(localId),
            userId: const Value(''),
            assetTypeCode: Value(typeCode),
            assetTypeId: Value(params.assetTypeId),
            amount: Value(amountDouble.toString()),
            priceAtEntry: Value(priceAtEntry.toString()),
            currentUnitPrice: const Value(''),
            entryDate: Value(params.entryDate),
            note: Value(params.note),
            pendingSync: const Value(true),
            createdAt: Value(now),
            updatedAt: Value(now),
            lastSyncedAt: const Value(null),
          ),
        );
      } catch (_) {}

      final result = await remoteDataSource.addAsset({
        SupabaseColumns.assetTypeId: params.assetTypeId,
        SupabaseColumns.amount: amountDouble,
        SupabaseColumns.priceAtEntry: priceAtEntry,
        SupabaseColumns.entryDate: entryDateStr,
        if (params.note != null) SupabaseColumns.note: params.note,
      });

      final serverId = result[SupabaseColumns.id] as String;
      final serverAmount = (result[SupabaseColumns.amount] as num).toDouble();
      final serverPrice = (result[SupabaseColumns.priceAtEntry] as num)
          .toDouble();
      final serverEntryDate = DateTime.parse(
        result[SupabaseColumns.entryDate] as String,
      );
      final serverNote = result[SupabaseColumns.note] as String?;

      try {
        await assetsDao.insertOrUpdate(
          CachedAssetsTableCompanion(
            id: Value(serverId),
            userId: const Value(''),
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
      } catch (_) {}

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
      return ResultFailure(mapSupabaseError(e, AssetOperation.add));
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
      await assetsDao.insertOrUpdate(
        CachedAssetsTableCompanion(
          id: Value(params.assetId),
          amount: Value(amountDouble.toString()),
          priceAtEntry: Value(priceAtEntry.toString()),
          entryDate: Value(params.entryDate),
          note: Value(params.note),
          pendingSync: const Value(true),
          updatedAt: Value(now),
        ),
      );
    } catch (_) {}

    try {
      final result = await remoteDataSource.updateAsset(params.assetId, {
        SupabaseColumns.amount: amountDouble,
        SupabaseColumns.priceAtEntry: priceAtEntry,
        SupabaseColumns.entryDate: entryDateStr,
        if (params.note != null) SupabaseColumns.note: params.note,
      });

      final serverAmount = (result[SupabaseColumns.amount] as num).toDouble();
      final serverPrice = (result[SupabaseColumns.priceAtEntry] as num)
          .toDouble();
      final serverEntryDate = DateTime.parse(
        result[SupabaseColumns.entryDate] as String,
      );
      final serverNote = result[SupabaseColumns.note] as String?;

      try {
        await assetsDao.insertOrUpdate(
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
      } catch (_) {}

      return Success(
        AssetEntity(
          id: params.assetId,
          assetType: assetTypeFromString(
            result[SupabaseTables.assetTypes] is Map
                ? ((result[SupabaseTables.assetTypes]
                              as Map)[SupabaseColumns.code]
                          as String? ??
                      '')
                : '',
          ),
          amount: serverAmount,
          priceAtEntry: serverPrice,
          entryDate: serverEntryDate,
          note: serverNote,
        ),
      );
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabaseError(e, AssetOperation.update));
    } catch (e) {
      return ResultFailure(AssetOperationFailure(AssetOperation.update, '$e'));
    }
  }

  Future<ApiResult<void>> softDeleteAssetWithSupport(String assetId) async {
    try {
      await assetsDao.deleteById(assetId);
    } catch (_) {}

    try {
      await remoteDataSource.softDeleteAsset(assetId);
      return const Success(null);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabaseError(e, AssetOperation.delete));
    } catch (e) {
      return ResultFailure(AssetOperationFailure(AssetOperation.delete, '$e'));
    }
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
      return ResultFailure(mapSupabaseError(e, AssetOperation.loadHistory));
    } catch (e) {
      return ResultFailure(
        AssetOperationFailure(AssetOperation.loadHistory, '$e'),
      );
    }
  }

  Failure mapSupabaseError(PostgrestException e, AssetOperation operation) {
    if (e.code == 'PGRST301' || e.message.contains('JWT')) {
      return SessionExpiredFailure(e.message, e.code);
    }
    return AssetOperationFailure(operation, e.message, e.code);
  }
}

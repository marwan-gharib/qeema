import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/local/cache/daos/assets_dao.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/asset_type_parsing.dart';
import 'package:qeema/features/assets/data/datasources/assets_remote_datasource.dart';
import 'package:qeema/features/assets/data/mappers/asset_history_mapper.dart';
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
      final typeRow = typeRows.firstWhere((r) => r['id'] == params.assetTypeId);
      final isMarketBased = typeRow['is_market_based'] as bool;
      final typeCode = typeRow['code'] as String;

      if (isMarketBased && params.priceAtEntry == null) {
        return const ResultFailure(
          ValidationFailure('Price is required for market-based assets.'),
        );
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
        'asset_type_id': params.assetTypeId,
        'amount': amountDouble,
        'price_at_entry': priceAtEntry,
        'entry_date': entryDateStr,
        if (params.note != null) 'note': params.note,
      });

      final serverId = result['id'] as String;
      final serverAmount = (result['amount'] as num).toDouble();
      final serverPrice = (result['price_at_entry'] as num).toDouble();
      final serverEntryDate = DateTime.parse(result['entry_date'] as String);
      final serverNote = result['note'] as String?;

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
      return ResultFailure(mapSupabaseError(e));
    } catch (e) {
      return const ResultFailure(
        ServerFailure('مش قادرين نضيف الأصل دلوقتي، حاول تاني.'),
      );
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
        'amount': amountDouble,
        'price_at_entry': priceAtEntry,
        'entry_date': entryDateStr,
        if (params.note != null) 'note': params.note,
      });

      final serverAmount = (result['amount'] as num).toDouble();
      final serverPrice = (result['price_at_entry'] as num).toDouble();
      final serverEntryDate = DateTime.parse(result['entry_date'] as String);
      final serverNote = result['note'] as String?;

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
            result['asset_types'] is Map
                ? ((result['asset_types'] as Map)['code'] as String? ?? '')
                : '',
          ),
          amount: serverAmount,
          priceAtEntry: serverPrice,
          entryDate: serverEntryDate,
          note: serverNote,
        ),
      );
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabaseError(e));
    } catch (e) {
      return const ResultFailure(ServerFailure('Update failed.'));
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
      return ResultFailure(mapSupabaseError(e));
    } catch (e) {
      return const ResultFailure(ServerFailure('Delete failed.'));
    }
  }

  Future<ApiResult<List<AssetHistoryEntryEntity>>> getAssetHistoryWithSupport(
    String assetId,
  ) async {
    try {
      final rows = await remoteDataSource.getAssetHistory(assetId);
      final entries = rows.map(AssetHistoryMapper.fromRow).toList();
      return Success(entries);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabaseError(e));
    } catch (e) {
      return const ResultFailure(ServerFailure('Failed to load history.'));
    }
  }

  List<AssetEntity> toEntities(List<AssetModelFromServer> models) {
    return models.map((m) {
      return AssetEntity(
        id: m.id,
        assetType: assetTypeFromString(m.assetTypeCode),
        amount: m.amount,
        priceAtEntry: m.priceAtEntry,
        entryDate: m.entryDate,
        note: m.note,
        currentPrice: m.currentPrice,
      );
    }).toList();
  }

  Failure mapSupabaseError(PostgrestException e) {
    if (e.code == 'PGRST301' || (e.message.contains('JWT'))) {
      return const AuthFailure('انتهت صلاحية الجلسة، سجّل دخول تاني.');
    }
    return const ServerFailure('مش قادرين نجيب بياناتك دلوقتي، حاول تاني.');
  }
}

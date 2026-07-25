import 'dart:math' as math;
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/local/cache/daos/assets_dao.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/data/datasources/assets_remote_datasource.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssetsRepositoryImpl implements AssetsRepository {
  AssetsRepositoryImpl(this._remoteDataSource, this._assetsDao);

  final AssetsRemoteDataSource _remoteDataSource;
  final AssetsDao _assetsDao;

  static final _random = math.Random();

  @override
  Future<ApiResult<List<AssetEntity>>> getAssets() async {
    try {
      final models = await _remoteDataSource.getAssets();
      return Success(_toEntities(models));
    } on PostgrestException catch (e) {
      return ResultFailure(_mapSupabaseError(e));
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
      return ResultFailure(_mapSupabaseError(e));
    } catch (e) {
      return const ResultFailure(UnknownFailure());
    }
  }

  @override
  Future<ApiResult<AssetEntity>> addAsset(AddAssetParams params) async {
    if (params.amount <= Decimal.zero) {
      return const ResultFailure(InvalidAssetAmountFailure());
    }

    try {
      final typeRows = await _remoteDataSource.getAssetTypes();
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
        await _assetsDao.insertOrUpdate(
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

      final result = await _remoteDataSource.addAsset({
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
        await _assetsDao.insertOrUpdate(
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
          assetType: _codeToEnum(typeCode),
          amount: serverAmount,
          priceAtEntry: serverPrice,
          entryDate: serverEntryDate,
          note: serverNote,
        ),
      );
    } on PostgrestException catch (e) {
      return ResultFailure(_mapSupabaseError(e));
    } catch (e) {
      return const ResultFailure(
        ServerFailure('مش قادرين نضيف الأصل دلوقتي، حاول تاني.'),
      );
    }
  }

  AssetType _codeToEnum(String code) {
    switch (code) {
      case 'cash_egp':
        return AssetType.egpCash;
      case 'usd':
        return AssetType.usdCash;
      case 'gold_21':
        return AssetType.gold21;
      case 'gold_24':
        return AssetType.gold24;
      default:
        return AssetType.egpCash;
    }
  }

  List<AssetEntity> _toEntities(List<AssetModelFromServer> models) {
    return models.map((m) {
      return AssetEntity(
        id: m.id,
        assetType: _codeToEnum(m.assetTypeCode),
        amount: m.amount,
        priceAtEntry: m.priceAtEntry,
        entryDate: m.entryDate,
        note: m.note,
        currentPrice: m.currentPrice,
      );
    }).toList();
  }

  Failure _mapSupabaseError(PostgrestException e) {
    if (e.code == 'PGRST301' || (e.message.contains('JWT'))) {
      return const AuthFailure('انتهت صلاحية الجلسة، سجّل دخول تاني.');
    }
    return const ServerFailure('مش قادرين نجيب بياناتك دلوقتي، حاول تاني.');
  }
}

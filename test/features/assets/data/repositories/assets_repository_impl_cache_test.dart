import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/domain/asset_type.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/data/models/asset_model_from_server.dart';
import 'package:qeema/features/assets/data/repositories/assets_repository_impl.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'mocks/mock_assets_dao.dart';
import 'mocks/mock_assets_remote_datasource.dart';

void main() {
  late MockAssetsRemoteDataSource mockRemote;
  late MockAssetsDao mockDao;
  late AssetsRepositoryImpl repository;

  setUp(() {
    mockRemote = MockAssetsRemoteDataSource();
    mockDao = MockAssetsDao();
    repository = AssetsRepositoryImpl(mockRemote, mockDao);

    mockRemote.assetTypesResult = [
      {
        'id': 'bb481548-6247-453e-bd38-ea0ee224bf65',
        'code': 'cash_egp',
        'name': 'Cash (EGP)',
        'is_market_based': false,
        'base_unit': 'EGP',
      },
      {
        'id': '2b576e25-9f64-4394-b831-83d3691de533',
        'code': 'usd',
        'name': 'US Dollar',
        'is_market_based': true,
        'base_unit': 'USD',
      },
    ];
  });

  group('AssetsRepositoryImpl.getAssets (offline-first)', () {
    test(
      'should answer from the cache without the network when the mirror is populated',
      () async {
        mockDao.rows.add(cachedRow());
        mockRemote.shouldThrow = true;

        final result = await repository.getAssets();

        expect(result, isA<Success<List<AssetEntity>>>());
        final assets = (result as Success<List<AssetEntity>>).data;
        expect(assets.single.id, 'a1');
        expect(assets.single.assetType, AssetType.egpCash);
        expect(assets.single.amount, 500);
      },
    );

    test(
      'should fetch the network and rewrite the mirror when the cache is empty',
      () async {
        mockRemote.assetsResult = [serverAsset()];

        final result = await repository.getAssets();

        expect(result, isA<Success<List<AssetEntity>>>());
        expect(
          (result as Success<List<AssetEntity>>).data.single.currentPrice,
          49,
        );
        expect(mockDao.rows.single.id, 'a1');
        expect(mockDao.rows.single.assetTypeCode, 'usd');
        expect(mockDao.rows.single.currentUnitPrice, '49.0');
      },
    );

    test(
      'should return a failure when the cache is empty and the network fails',
      () async {
        mockRemote.shouldThrow = true;

        final result = await repository.getAssets();

        expect(result, isA<ResultFailure<List<AssetEntity>>>());
      },
    );

    test(
      'should skip a corrupted cache row instead of returning a fabricated amount',
      () async {
        mockDao.rows
          ..add(cachedRow(id: 'broken', amount: 'abc'))
          ..add(cachedRow(id: 'good'));

        final result = await repository.getAssets();

        final assets = (result as Success<List<AssetEntity>>).data;
        expect(assets.single.id, 'good');
      },
    );
  });

  group('AssetsRepositoryImpl.refreshAssets', () {
    test(
      'should return fresh network data and drop stale mirror rows when it succeeds',
      () async {
        mockDao.rows.add(cachedRow(id: 'stale-row'));
        mockRemote.assetsResult = [serverAsset(id: 'fresh')];

        final result = await repository.refreshAssets();

        expect((result as Success<List<AssetEntity>>).data.single.id, 'fresh');
        expect(mockDao.rows.single.id, 'fresh');
      },
    );

    test('should serve the stale cache when the network fails', () async {
      mockDao.rows.add(cachedRow(id: 'a1'));
      mockRemote.shouldThrow = true;

      final result = await repository.refreshAssets();

      expect((result as Success<List<AssetEntity>>).data.single.id, 'a1');
    });

    test(
      'should return a failure when both the network and the cache fail',
      () async {
        mockRemote.shouldThrow = true;
        mockDao.shouldThrow = true;

        final result = await repository.refreshAssets();

        expect(result, isA<ResultFailure<List<AssetEntity>>>());
      },
    );
  });

  group('AssetsRepositoryImpl cache mirror on writes', () {
    test(
      'should mirror the server row to the cache after a successful add',
      () async {
        mockRemote.addAssetResult = {
          'id': 'new-1',
          'amount': 500,
          'price_at_entry': 1,
          'entry_date': '2026-07-25',
        };

        await repository.addAsset(
          AddAssetParams(
            assetTypeId: 'bb481548-6247-453e-bd38-ea0ee224bf65',
            amount: Decimal.parse('500'),
            entryDate: DateTime(2026, 7, 25),
          ),
        );

        expect(mockDao.rows.single.id, 'new-1');
        expect(mockDao.rows.single.amount, '500.0');
      },
    );

    test('should not write the cache when the remote add fails', () async {
      mockRemote.shouldThrow = true;

      await repository.addAsset(
        AddAssetParams(
          assetTypeId: 'bb481548-6247-453e-bd38-ea0ee224bf65',
          amount: Decimal.parse('500'),
          entryDate: DateTime(2026, 7, 25),
        ),
      );

      expect(mockDao.rows, isEmpty);
    });

    test(
      'should mirror the server update to the cache after a successful update',
      () async {
        mockRemote.updateAssetResult = {
          'id': 'a1',
          'amount': 300,
          'price_at_entry': 2,
          'entry_date': '2026-07-25',
          'asset_types': {'code': 'cash_egp'},
        };
        mockDao.rows.add(cachedRow());

        final result = await repository.updateAsset(
          UpdateAssetParams(
            assetId: 'a1',
            amount: Decimal.parse('300'),
            entryDate: DateTime(2026, 7, 25),
          ),
        );

        expect(result, isA<Success<AssetEntity>>());
        expect(mockDao.rows.single.amount, '300.0');
      },
    );

    test('should keep the cache row when the remote update fails', () async {
      mockDao.rows.add(cachedRow());
      mockRemote.shouldThrow = true;

      await repository.updateAsset(
        UpdateAssetParams(
          assetId: 'a1',
          amount: Decimal.parse('300'),
          entryDate: DateTime(2026, 7, 25),
        ),
      );

      expect(mockDao.rows.single.amount, '500');
    });

    test('should drop the cache row after a successful delete', () async {
      mockDao.rows.add(cachedRow(id: 'a1'));

      final result = await repository.softDeleteAsset('a1');

      expect(result, isA<Success<void>>());
      expect(mockDao.rows, isEmpty);
    });

    test('should keep the cache row when the remote delete fails', () async {
      mockDao.rows.add(cachedRow(id: 'a1'));
      mockRemote.shouldThrow = true;

      final result = await repository.softDeleteAsset('a1');

      expect(result, isA<ResultFailure<void>>());
      expect(mockDao.rows.single.id, 'a1');
    });
  });
}

CachedAssetsTableData cachedRow({
  String id = 'a1',
  String code = 'cash_egp',
  String amount = '500',
  String priceAtEntry = '1',
}) {
  return CachedAssetsTableData(
    id: id,
    userId: '',
    assetTypeCode: code,
    assetTypeId: 'type-1',
    amount: amount,
    priceAtEntry: priceAtEntry,
    currentUnitPrice: '',
    entryDate: DateTime(2026, 7, 25),
    note: null,
    pendingSync: false,
    lastSyncedAt: null,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

AssetModelFromServer serverAsset({String id = 'a1'}) {
  return AssetModelFromServer(
    id: id,
    assetTypeCode: 'usd',
    amount: 200,
    priceAtEntry: 48.5,
    entryDate: DateTime(2026, 7, 25),
    currentPrice: 49,
  );
}

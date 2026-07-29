import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/data/repositories/assets_repository_impl.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
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

  group('AssetsRepositoryImpl.addAsset', () {
    test(
      'cash_egp submission substitutes Decimal.one for null priceAtEntry',
      () async {
        mockRemote.addAssetResult = {
          'id': 'new-asset-id',
          'amount': 500,
          'price_at_entry': 1,
          'entry_date': '2026-07-25',
        };

        final result = await repository.addAsset(
          AddAssetParams(
            assetTypeId: 'bb481548-6247-453e-bd38-ea0ee224bf65',
            amount: Decimal.parse('500'),
            entryDate: DateTime(2026, 7, 25),
          ),
        );

        expect(result, isA<Success<AssetEntity>>());
        final entity = (result as Success).data;
        expect(entity.amount, 500);
        expect(entity.priceAtEntry, 1);
      },
    );

    test(
      'market-based type with null priceAtEntry returns ValidationFailure',
      () async {
        final result = await repository.addAsset(
          AddAssetParams(
            assetTypeId: '2b576e25-9f64-4394-b831-83d3691de533',
            amount: Decimal.parse('100'),
            entryDate: DateTime(2026, 7, 25),
          ),
        );

        expect(result, isA<ResultFailure<AssetEntity>>());
        (result as ResultFailure).fold(
          onSuccess: (_) => fail('Expected failure'),
          onFailure: (failure) {
            expect(failure, isA<ValidationFailure>());
          },
        );
      },
    );

    test('amount <= 0 returns InvalidAssetAmountFailure', () async {
      final result = await repository.addAsset(
        AddAssetParams(
          assetTypeId: 'bb481548-6247-453e-bd38-ea0ee224bf65',
          amount: Decimal.zero,
          entryDate: DateTime(2026, 7, 25),
        ),
      );

      expect(result, isA<ResultFailure<AssetEntity>>());
      (result as ResultFailure).fold(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (failure) {
          expect(failure, isA<InvalidAssetAmountFailure>());
        },
      );
    });

    test('successful write returns asset entity with correct type', () async {
      mockRemote.addAssetResult = {
        'id': 'new-asset-id',
        'amount': 200,
        'price_at_entry': 48.5,
        'entry_date': '2026-07-25',
      };

      final result = await repository.addAsset(
        AddAssetParams(
          assetTypeId: '2b576e25-9f64-4394-b831-83d3691de533',
          amount: Decimal.parse('200'),
          priceAtEntry: Decimal.parse('48.5'),
          entryDate: DateTime(2026, 7, 25),
        ),
      );

      expect(result, isA<Success<AssetEntity>>());
      final entity = (result as Success).data;
      expect(entity.assetType, AssetType.usdCash);
      expect(entity.amount, 200);
      expect(entity.priceAtEntry, 48.5);
    });
  });
}

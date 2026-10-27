import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/domain/asset_type.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/features/assets/data/models/asset_model_from_server.dart';
import 'package:qeema/features/assets/data/models/cached_asset_model.dart';

CachedAssetsTableData _data({
  String amount = '200',
  String priceAtEntry = '48.5',
  String currentUnitPrice = '49',
  String assetTypeCode = 'usd',
  String? note = 'n',
}) {
  return CachedAssetsTableData(
    id: 'a1',
    userId: AppConstants.localCacheUserId,
    assetTypeCode: assetTypeCode,
    assetTypeId: 'type-1',
    amount: amount,
    priceAtEntry: priceAtEntry,
    currentUnitPrice: currentUnitPrice,
    entryDate: DateTime(2026, 7, 25),
    note: note,
    pendingSync: false,
    lastSyncedAt: null,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

AssetModelFromServer _model() {
  return AssetModelFromServer(
    id: 'a1',
    assetTypeCode: 'usd',
    amount: 200,
    priceAtEntry: 48.5,
    entryDate: DateTime(2026, 7, 25),
    note: 'n',
    currentPrice: 49,
  );
}

void main() {
  group('CachedAssetsTableData.tryToEntity', () {
    test('maps every stored column to the entity', () {
      final entity = _data().tryToEntity();

      expect(entity, isNotNull);
      expect(entity!.id, 'a1');
      expect(entity.assetType.index, AssetType.usdCash.index);
      expect(entity.amount, 200);
      expect(entity.priceAtEntry, 48.5);
      expect(entity.entryDate, DateTime(2026, 7, 25));
      expect(entity.note, 'n');
      expect(entity.currentPrice, 49);
    });

    test('treats an empty currentUnitPrice as unknown current price', () {
      final entity = _data(currentUnitPrice: '').tryToEntity();

      expect(entity!.currentPrice, isNull);
    });

    test('returns null for an unparsable amount', () {
      expect(_data(amount: 'abc').tryToEntity(), isNull);
    });

    test('returns null for an unparsable priceAtEntry', () {
      expect(_data(priceAtEntry: '').tryToEntity(), isNull);
    });

    test('returns null for an unknown type code', () {
      expect(_data(assetTypeCode: 'silver').tryToEntity(), isNull);
    });
  });

  group('AssetModelFromServer.toCacheCompanion', () {
    test('carries every column the mirror needs', () {
      final companion = _model().toCacheCompanion();

      expect(companion.id.value, 'a1');
      expect(companion.userId.value, AppConstants.localCacheUserId);
      expect(companion.assetTypeCode.value, 'usd');
      expect(companion.amount.value, '200.0');
      expect(companion.priceAtEntry.value, '48.5');
      expect(companion.currentUnitPrice.value, '49.0');
      expect(companion.entryDate.value, DateTime(2026, 7, 25));
      expect(companion.note.value, 'n');
      expect(companion.pendingSync.value, isFalse);
    });

    test('stores a missing current price as an empty marker', () {
      final model = AssetModelFromServer(
        id: 'a1',
        assetTypeCode: 'cash_egp',
        amount: 500,
        priceAtEntry: 1,
        entryDate: DateTime(2026, 7, 25),
      );

      final companion = model.toCacheCompanion();

      expect(companion.currentUnitPrice.value, '');
      expect(companion.note.value, isNull);
    });
  });
}

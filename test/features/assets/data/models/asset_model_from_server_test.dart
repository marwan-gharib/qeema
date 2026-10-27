import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/core/constants/supabase_tables.dart';
import 'package:qeema/core/domain/asset_type.dart';
import 'package:qeema/core/error/exceptions.dart';
import 'package:qeema/features/assets/data/models/asset_model_from_server.dart';

Map<String, dynamic> _row({Object? code = 'usd', Object? note = 'savings'}) {
  return {
    SupabaseColumns.id: 'a1',
    SupabaseColumns.amount: 200,
    SupabaseColumns.priceAtEntry: 48.5,
    SupabaseColumns.entryDate: '2026-07-25',
    SupabaseColumns.note: ?note,
    SupabaseTables.assetTypes: {SupabaseColumns.code: ?code},
  };
}

void main() {
  group('AssetModelFromServer.fromJson', () {
    test('maps a joined row field by field', () {
      final model = AssetModelFromServer.fromJson(_row(), currentPrice: 49);

      expect(model.id, 'a1');
      expect(model.assetTypeCode, 'usd');
      expect(model.amount, 200);
      expect(model.priceAtEntry, 48.5);
      expect(model.entryDate, DateTime(2026, 7, 25));
      expect(model.note, 'savings');
      expect(model.currentPrice, 49);
    });

    test('accepts a missing type join as an empty code', () {
      final model = AssetModelFromServer.fromJson(
        _row(code: null),
        currentPrice: null,
      );

      expect(model.assetTypeCode, '');
      expect(model.note, 'savings');
      expect(model.currentPrice, isNull);
    });

    test('treats a non-String type code as malformed', () {
      expect(
        () => AssetModelFromServer.fromJson(_row(code: 42)),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('AssetModelFromServer.toEntity', () {
    test('maps every field including the derived asset type', () {
      final entity = AssetModelFromServer.fromJson(
        _row(),
        currentPrice: 49,
      ).toEntity();

      expect(entity.id, 'a1');
      expect(entity.assetType, AssetType.usdCash);
      expect(entity.amount, 200);
      expect(entity.priceAtEntry, 48.5);
      expect(entity.entryDate, DateTime(2026, 7, 25));
      expect(entity.note, 'savings');
      expect(entity.currentPrice, 49);
    });
  });
}

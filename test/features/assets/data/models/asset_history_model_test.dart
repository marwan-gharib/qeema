import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/core/error/exceptions.dart';
import 'package:qeema/features/assets/data/models/asset_history_model.dart';

Map<String, dynamic> _row({
  Object? oldValue = const <String, dynamic>{'amount': 100},
  Object? newValue = const <String, dynamic>{'amount': 200},
}) {
  return {
    SupabaseColumns.id: 'h1',
    SupabaseColumns.assetId: 'a1',
    SupabaseColumns.changeType: 'amount',
    SupabaseColumns.changedAt: '2026-07-26T10:00:00.000Z',
    SupabaseColumns.oldValue: ?oldValue,
    SupabaseColumns.newValue: ?newValue,
  };
}

void main() {
  group('AssetHistoryModel.fromRow', () {
    test('maps a full history row', () {
      final model = AssetHistoryModel.fromRow(_row());

      expect(model.id, 'h1');
      expect(model.assetId, 'a1');
      expect(model.changeType, 'amount');
      expect(model.oldValue, isNotNull);
      expect(model.newValue, isNotNull);
      expect(model.changedAt, DateTime.parse('2026-07-26T10:00:00.000Z'));
    });

    test('accepts absent old/new values as null', () {
      final model = AssetHistoryModel.fromRow(
        _row(oldValue: null, newValue: null),
      );

      expect(model.oldValue, isNull);
      expect(model.newValue, isNull);
    });

    test('rejects a missing required key as malformed', () {
      final row = _row()..remove(SupabaseColumns.changeType);

      expect(
        () => AssetHistoryModel.fromRow(row),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('AssetHistoryModel.toEntity', () {
    test('carries every field to the entity', () {
      final entity = AssetHistoryModel.fromRow(_row()).toEntity();

      expect(entity.id, 'h1');
      expect(entity.assetId, 'a1');
      expect(entity.changeType, 'amount');
      expect(entity.oldValue, isNotNull);
      expect(entity.newValue, isNotNull);
      expect(entity.changedAt, DateTime.parse('2026-07-26T10:00:00.000Z'));
    });
  });
}

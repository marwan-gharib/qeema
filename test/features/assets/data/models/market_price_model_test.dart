import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/core/error/exceptions.dart';
import 'package:qeema/features/assets/data/models/market_price_model.dart';

Map<String, dynamic> _row({Object? fetchedAt}) {
  return {
    SupabaseColumns.priceDate: '2026-08-14',
    SupabaseColumns.price: 126.5,
    SupabaseColumns.fetchedAt: ?fetchedAt,
  };
}

void main() {
  group('MarketPriceModel.fromRow', () {
    test('maps a price row with a fetchedAt timestamp', () {
      final model = MarketPriceModel.fromRow(
        _row(fetchedAt: '2026-08-14T06:00:00.000Z'),
      );

      expect(model.priceDate, DateTime(2026, 8, 14));
      expect(model.price, Decimal.parse('126.5'));
      expect(model.fetchedAt, DateTime.parse('2026-08-14T06:00:00.000Z'));
    });

    test('accepts an absent fetchedAt as null', () {
      final model = MarketPriceModel.fromRow(_row());

      expect(model.fetchedAt, isNull);
    });

    test('rejects an unparsable fetchedAt as malformed', () {
      expect(
        () => MarketPriceModel.fromRow(_row(fetchedAt: 'not-a-date')),
        throwsA(isA<ServerException>()),
      );
    });

    test('rejects a non-num price as malformed', () {
      final row = _row()..[SupabaseColumns.price] = 'free';

      expect(
        () => MarketPriceModel.fromRow(row),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('MarketPriceModel.toEntity', () {
    test('carries every field to the entity', () {
      final entity = MarketPriceModel.fromRow(
        _row(fetchedAt: '2026-08-14T06:00:00.000Z'),
      ).toEntity();

      expect(entity.priceDate, DateTime(2026, 8, 14));
      expect(entity.price, Decimal.parse('126.5'));
      expect(entity.fetchedAt, DateTime.parse('2026-08-14T06:00:00.000Z'));
    });
  });
}

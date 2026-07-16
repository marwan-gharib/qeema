import 'package:drift/drift.dart';

class CachedMarketPricesTable extends Table {
  TextColumn get id => text()();
  TextColumn get assetTypeCode => text()();
  TextColumn get price => text()();
  TextColumn get currency => text()();
  DateTimeColumn get fetchedAt => dateTime()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

import 'package:drift/drift.dart';

class CachedInflationRatesTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get month => dateTime()();
  TextColumn get rate => text()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

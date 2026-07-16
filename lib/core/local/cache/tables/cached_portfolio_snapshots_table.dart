import 'package:drift/drift.dart';

class CachedPortfolioSnapshotsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get nominalValue => text()();
  TextColumn get realValue => text()();
  DateTimeColumn get snapshotDate => dateTime()();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

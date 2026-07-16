import 'package:drift/drift.dart';

class CachedSavingsGoalsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get targetAmount => text()();
  TextColumn get targetAssetTypeCode => text()();
  DateTimeColumn get targetDate => dateTime()();
  TextColumn get currentAmount => text().withDefault(const Constant('0'))();
  BoolColumn get pendingSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

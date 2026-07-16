import 'package:drift/drift.dart';

class CachedAssetsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get assetTypeCode => text()();
  TextColumn get assetTypeId => text()();
  TextColumn get amount => text()();
  TextColumn get priceAtEntry => text()();
  TextColumn get currentUnitPrice => text()();
  DateTimeColumn get entryDate => dateTime()();
  TextColumn get note => text().nullable()();
  BoolColumn get pendingSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

import 'package:drift/drift.dart';

import '../app_database.dart';

class InflationRatesDao {
  final AppDatabase _db;
  const InflationRatesDao(this._db);

  Future<List<CachedInflationRatesTableData>> getAll() async {
    return await _db.select(_db.cachedInflationRatesTable).get();
  }

  Future<List<CachedInflationRatesTableData>> getRange({
    required DateTime from,
    required DateTime to,
  }) async {
    return await (_db.select(_db.cachedInflationRatesTable)..where(
          (t) =>
              t.month.isBiggerThan(Variable(from)) &
              t.month.isSmallerThan(Variable(to)),
        ))
        .get();
  }

  Future<void> insertOrUpdate(CachedInflationRatesTableCompanion entry) async {
    await _db.into(_db.cachedInflationRatesTable).insertOnConflictUpdate(entry);
  }
}

import 'package:drift/drift.dart';

import '../app_database.dart';

class GoalsDao {
  final AppDatabase _db;
  const GoalsDao(this._db);

  Future<List<CachedSavingsGoalsTableData>> forUser(String userId) async {
    return await (_db.select(
      _db.cachedSavingsGoalsTable,
    )..where((t) => t.userId.equals(userId))).get();
  }

  Future<void> insertOrUpdate(CachedSavingsGoalsTableCompanion entry) async {
    await _db.into(_db.cachedSavingsGoalsTable).insertOnConflictUpdate(entry);
  }

  Future<void> markPendingSync(String id) async {
    await (_db.update(
      _db.cachedSavingsGoalsTable,
    )..where((t) => t.id.equals(id))).write(
      const CachedSavingsGoalsTableCompanion(pendingSync: Value(true)),
    );
  }

  Future<void> deleteById(String id) async {
    await (_db.delete(
      _db.cachedSavingsGoalsTable,
    )..where((t) => t.id.equals(id))).go();
  }

  Future<List<CachedSavingsGoalsTableData>> pendingSyncItems() async {
    return await (_db.select(
      _db.cachedSavingsGoalsTable,
    )..where((t) => t.pendingSync.equals(true))).get();
  }
}

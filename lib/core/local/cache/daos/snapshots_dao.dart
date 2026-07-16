import 'package:drift/drift.dart';

import '../app_database.dart';

class SnapshotsDao {
  final AppDatabase _db;
  const SnapshotsDao(this._db);

  Future<List<CachedPortfolioSnapshotsTableData>> forUser(String userId) async {
    return await (_db.select(_db.cachedPortfolioSnapshotsTable)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.snapshotDate)]))
        .get();
  }

  Future<void> insertOrUpdate(
    CachedPortfolioSnapshotsTableCompanion entry,
  ) async {
    await _db
        .into(_db.cachedPortfolioSnapshotsTable)
        .insertOnConflictUpdate(entry);
  }
}

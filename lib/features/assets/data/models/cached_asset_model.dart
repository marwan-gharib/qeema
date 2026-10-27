import 'package:drift/drift.dart' show Value;
import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/utils/asset_type_parsing.dart';
import 'package:qeema/features/assets/data/models/asset_model_from_server.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

/// Bridges the drift cache row and the domain entity. The cached table is a
/// mirror of the server list, so conversion goes both ways — keeping it beside
/// the models honors DATA-5 (no field-by-field conversion in the repository).
extension CachedAssetsTableDataX on CachedAssetsTableData {
  /// Null when a column is unparsable or the type code is unknown (corrupted
  /// row) — the caller skips the row instead of showing a fabricated amount.
  AssetEntity? tryToEntity() {
    final parsedAmount = double.tryParse(amount);
    final parsedPriceAtEntry = double.tryParse(priceAtEntry);
    if (parsedAmount == null || parsedPriceAtEntry == null) return null;
    try {
      return AssetEntity(
        id: id,
        assetType: assetTypeFromString(assetTypeCode),
        amount: parsedAmount,
        priceAtEntry: parsedPriceAtEntry,
        entryDate: entryDate,
        note: note,
        currentPrice: double.tryParse(currentUnitPrice),
      );
    } on FormatException {
      return null;
    }
  }
}

extension AssetModelFromServerX on AssetModelFromServer {
  /// The cache-row form of a freshly fetched server asset.
  CachedAssetsTableCompanion toCacheCompanion() {
    final now = DateTime.now();
    return CachedAssetsTableCompanion(
      id: Value(id),
      userId: const Value(AppConstants.localCacheUserId),
      assetTypeCode: Value(assetTypeCode),
      assetTypeId: const Value(''),
      amount: Value(amount.toString()),
      priceAtEntry: Value(priceAtEntry.toString()),
      currentUnitPrice: Value(currentPrice?.toString() ?? ''),
      entryDate: Value(entryDate),
      note: Value(note),
      pendingSync: const Value(false),
      createdAt: Value(now),
      updatedAt: Value(now),
      lastSyncedAt: Value(now),
    );
  }
}

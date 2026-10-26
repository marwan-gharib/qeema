import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';

class AssetHistoryMapper {
  const AssetHistoryMapper._();

  static AssetHistoryEntryEntity fromRow(Map<String, dynamic> row) {
    return AssetHistoryEntryEntity(
      id: row[SupabaseColumns.id] as String,
      assetId: row[SupabaseColumns.assetId] as String,
      changeType: row[SupabaseColumns.changeType] as String,
      oldValue: (row[SupabaseColumns.oldValue] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v),
      ),
      newValue: (row[SupabaseColumns.newValue] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v),
      ),
      changedAt: DateTime.parse(row[SupabaseColumns.changedAt] as String),
    );
  }
}

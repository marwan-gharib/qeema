import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';

class AssetHistoryMapper {
  const AssetHistoryMapper._();

  static AssetHistoryEntryEntity fromRow(Map<String, dynamic> row) {
    return AssetHistoryEntryEntity(
      id: row['id'] as String,
      assetId: row['asset_id'] as String,
      changeType: row['change_type'] as String,
      oldValue: (row['old_value'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v),
      ),
      newValue: (row['new_value'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v),
      ),
      changedAt: DateTime.parse(row['changed_at'] as String),
    );
  }
}

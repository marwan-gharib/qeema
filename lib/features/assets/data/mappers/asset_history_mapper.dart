import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';

class AssetHistoryMapper {
  const AssetHistoryMapper._();

  static const _fieldLabels = {
    'amount': 'Amount',
    'price_at_entry': 'Entry price',
    'entry_date': 'Entry date',
    'note': 'Note',
  };

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

  static String summarizeChange(AssetHistoryEntryEntity entry) {
    switch (entry.changeType) {
      case 'created':
        return 'Asset added';
      case 'deleted':
        return 'Asset deleted';
      case 'updated':
        return _summarizeUpdate(entry);
      default:
        return 'Updated';
    }
  }

  static String _summarizeUpdate(AssetHistoryEntryEntity entry) {
    final oldVal = entry.oldValue ?? {};
    final newVal = entry.newValue ?? {};
    final changes = <String>[];

    for (final key in _fieldLabels.keys) {
      if (!newVal.containsKey(key) && !oldVal.containsKey(key)) continue;
      final oldV = oldVal[key];
      final newV = newVal[key];
      if (oldV?.toString() != newV?.toString()) {
        final label = _fieldLabels[key] ?? key;
        if (key == 'note') {
          changes.add('$label updated');
        } else if (key == 'entry_date') {
          changes.add('$label changed');
        } else {
          changes.add('$label: ${oldV ?? "-"} → ${newV ?? "-"}');
        }
      }
    }
    return changes.isEmpty ? 'Updated' : changes.join('; ');
  }
}

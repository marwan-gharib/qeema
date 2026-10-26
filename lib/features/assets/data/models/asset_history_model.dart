import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';

/// One asset_history server row, parsed at the data-layer boundary.
class AssetHistoryModel {
  const AssetHistoryModel({
    required this.id,
    required this.assetId,
    required this.changeType,
    required this.changedAt,
    this.oldValue,
    this.newValue,
  });

  factory AssetHistoryModel.fromRow(Map<String, dynamic> row) {
    return AssetHistoryModel(
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

  final String id;
  final String assetId;
  final String changeType;
  final Map<String, dynamic>? oldValue;
  final Map<String, dynamic>? newValue;
  final DateTime changedAt;

  AssetHistoryEntryEntity toEntity() => AssetHistoryEntryEntity(
    id: id,
    assetId: assetId,
    changeType: changeType,
    oldValue: oldValue,
    newValue: newValue,
    changedAt: changedAt,
  );
}

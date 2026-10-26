import 'package:qeema/core/constants/supabase_columns.dart';
import 'package:qeema/features/assets/data/models/row_parsing.dart';
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
      id: requiredString(row, SupabaseColumns.id),
      assetId: requiredString(row, SupabaseColumns.assetId),
      changeType: requiredString(row, SupabaseColumns.changeType),
      oldValue: optionalMap(row, SupabaseColumns.oldValue),
      newValue: optionalMap(row, SupabaseColumns.newValue),
      changedAt: requiredDate(row, SupabaseColumns.changedAt),
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

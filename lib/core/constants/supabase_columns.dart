/// Supabase column and row-field names (ARCH-10). Used in query builders
/// (`select` / `eq` / `order`) and when parsing Postgrest row maps.
abstract final class SupabaseColumns {
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String isDeleted = 'is_deleted';
  static const String deletedAt = 'deleted_at';
  static const String isActive = 'is_active';
  static const String isMarketBased = 'is_market_based';
  static const String code = 'code';
  static const String name = 'name';
  static const String baseUnit = 'base_unit';
  static const String assetTypeId = 'asset_type_id';
  static const String assetId = 'asset_id';
  static const String amount = 'amount';
  static const String priceAtEntry = 'price_at_entry';
  static const String currentUnitPrice = 'current_unit_price';
  static const String entryDate = 'entry_date';
  static const String note = 'note';
  static const String price = 'price';
  static const String priceDate = 'price_date';
  static const String fetchedAt = 'fetched_at';
  static const String changeType = 'change_type';
  static const String oldValue = 'old_value';
  static const String newValue = 'new_value';
  static const String changedAt = 'changed_at';
  static const String month = 'month';
  static const String rate = 'rate';
  static const String snapshotDate = 'snapshot_date';
  static const String totalNominalValue = 'total_nominal_value';
  static const String totalRealValue = 'total_real_value';
}

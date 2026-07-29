class AssetHistoryEntryEntity {
  const AssetHistoryEntryEntity({
    required this.id,
    required this.assetId,
    required this.changeType,
    this.oldValue,
    this.newValue,
    required this.changedAt,
  });

  final String id;
  final String assetId;
  final String changeType;
  final Map<String, dynamic>? oldValue;
  final Map<String, dynamic>? newValue;
  final DateTime changedAt;
}

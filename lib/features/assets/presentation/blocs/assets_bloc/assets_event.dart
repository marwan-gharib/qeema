import 'package:decimal/decimal.dart';

sealed class AssetsEvent {
  const AssetsEvent();
}

final class AssetsSubscriptionRequested extends AssetsEvent {
  const AssetsSubscriptionRequested();
}

final class AssetFilterChanged extends AssetsEvent {
  const AssetFilterChanged(this.filterType);
  final String? filterType;
}

final class AssetSortChanged extends AssetsEvent {
  const AssetSortChanged(this.sortBy);
  final String sortBy;
}

final class AssetDeleted extends AssetsEvent {
  const AssetDeleted(this.assetId);
  final String assetId;
}

final class AssetAdded extends AssetsEvent {
  const AssetAdded({
    required this.assetTypeId,
    required this.assetTypeCode,
    required this.amount,
    required this.priceAtEntry,
    required this.entryDate,
    this.note,
  });
  final String assetTypeId;
  final String assetTypeCode;
  final Decimal amount;
  final Decimal priceAtEntry;
  final DateTime entryDate;
  final String? note;
}

final class AssetUpdated extends AssetsEvent {
  const AssetUpdated({
    required this.id,
    required this.amount,
    required this.priceAtEntry,
    this.note,
  });
  final String id;
  final Decimal amount;
  final Decimal priceAtEntry;
  final String? note;
}

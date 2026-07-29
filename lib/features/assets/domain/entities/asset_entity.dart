enum AssetType { egpCash, usdCash, gold21, gold24 }

class AssetEntity {
  const AssetEntity({
    required this.id,
    required this.assetType,
    required this.amount,
    required this.priceAtEntry,
    required this.entryDate,
    this.note,
    this.currentPrice,
  });

  final String id;
  final AssetType assetType;
  final double amount;
  final double priceAtEntry;
  final DateTime entryDate;
  final String? note;
  final double? currentPrice;

  double get entryValue => amount * priceAtEntry;

  double? get currentValue =>
      currentPrice == null ? null : amount * currentPrice!;

  double? get gainLossAmount =>
      currentValue == null ? null : currentValue! - entryValue;

  double? get gainLossPercent {
    if (currentValue == null || entryValue == 0) return null;
    return ((currentValue! - entryValue) / entryValue) * 100;
  }

  bool get isGain => (gainLossAmount ?? 0) >= 0;
}

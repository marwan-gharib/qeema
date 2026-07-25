import 'package:decimal/decimal.dart';

class UpdateAssetParams {
  const UpdateAssetParams({
    required this.assetId,
    required this.amount,
    this.priceAtEntry,
    required this.entryDate,
    this.note,
  });

  final String assetId;
  final Decimal amount;
  final Decimal? priceAtEntry;
  final DateTime entryDate;
  final String? note;
}

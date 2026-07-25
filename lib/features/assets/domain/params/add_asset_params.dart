import 'package:decimal/decimal.dart';

class AddAssetParams {
  const AddAssetParams({
    required this.assetTypeId,
    required this.amount,
    this.priceAtEntry,
    required this.entryDate,
    this.note,
  });

  final String assetTypeId;
  final Decimal amount;
  final Decimal? priceAtEntry;
  final DateTime entryDate;
  final String? note;
}

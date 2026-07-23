import 'package:decimal/decimal.dart';

class AddAssetParams {
  const AddAssetParams({
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

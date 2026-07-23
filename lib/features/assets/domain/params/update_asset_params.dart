import 'package:decimal/decimal.dart';

class UpdateAssetParams {
  const UpdateAssetParams({
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

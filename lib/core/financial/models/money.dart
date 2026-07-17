import 'package:decimal/decimal.dart';

class Money {
  const Money({required this.amount, required this.assetTypeCode});
  final Decimal amount;
  final String assetTypeCode;
}

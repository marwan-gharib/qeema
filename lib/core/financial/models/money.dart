import 'package:decimal/decimal.dart';

class Money {
  final Decimal amount;
  final String assetTypeCode;
  const Money({required this.amount, required this.assetTypeCode});
}

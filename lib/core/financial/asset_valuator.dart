import 'package:decimal/decimal.dart';

class AssetValuator {
  Decimal _d(dynamic v) => Decimal.parse(v.toString());

  Decimal currentValue({
    required Decimal amount,
    required Decimal currentUnitPrice,
  }) => _d(amount * currentUnitPrice);

  Decimal unrealizedGainLoss({
    required Decimal amount,
    required Decimal priceAtEntry,
    required Decimal currentUnitPrice,
  }) => _d(
    currentValue(amount: amount, currentUnitPrice: currentUnitPrice) -
        (amount * priceAtEntry),
  );

  Decimal gainLossPercentage({
    required Decimal amount,
    required Decimal priceAtEntry,
    required Decimal currentUnitPrice,
  }) {
    final cost = _d(amount * priceAtEntry);
    if (cost == Decimal.zero) return Decimal.zero;
    return _d(
          unrealizedGainLoss(
                amount: amount,
                priceAtEntry: priceAtEntry,
                currentUnitPrice: currentUnitPrice,
              ) /
              cost,
        ) *
        Decimal.fromInt(100);
  }
}

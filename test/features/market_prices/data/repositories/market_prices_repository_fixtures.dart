import 'package:decimal/decimal.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/entities/market_price_entity.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_market_price_history_usecase.dart';

const usdType = AssetTypeEntity(
  id: 'type-usd',
  code: 'usd',
  name: 'US Dollar',
  isMarketBased: true,
  baseUnit: 'USD',
);

const goldType = AssetTypeEntity(
  id: 'type-gold',
  code: 'gold_21',
  name: 'Gold 21K',
  isMarketBased: true,
  baseUnit: 'gram',
);

const egpType = AssetTypeEntity(
  id: 'type-egp',
  code: 'cash_egp',
  name: 'Cash (EGP)',
  isMarketBased: false,
  baseUnit: 'EGP',
);

class MockGetAssetTypesUseCase implements GetAssetTypesUseCase {
  ApiResult<List<AssetTypeEntity>> result = const Success([]);
  int callCount = 0;

  @override
  Future<ApiResult<List<AssetTypeEntity>>> call() async {
    callCount++;
    return result;
  }
}

class MockGetMarketPriceHistoryUseCase implements GetMarketPriceHistoryUseCase {
  ApiResult<List<MarketPriceEntity>> result = const Success([]);
  Map<String, ApiResult<List<MarketPriceEntity>>> resultForCode = {};
  final List<String> requestedCodes = [];

  @override
  Future<ApiResult<List<MarketPriceEntity>>> call(String assetTypeCode) async {
    requestedCodes.add(assetTypeCode);
    return resultForCode[assetTypeCode] ?? result;
  }
}

MarketPriceEntity price(String date, String value, {DateTime? fetchedAt}) {
  return MarketPriceEntity(
    priceDate: DateTime.parse(date),
    price: Decimal.parse(value),
    fetchedAt: fetchedAt,
  );
}

/// 14 daily rows ending 2026-08-14, starting at 100 with a steady rise.
List<MarketPriceEntity> dailyHistory({DateTime? fetchedAt}) {
  return [
    for (var i = 0; i < 14; i++)
      price(
        '2026-08-${(1 + i).toString().padLeft(2, '0')}',
        (100.0 + i * 2).toString(),
        fetchedAt: fetchedAt,
      ),
  ];
}

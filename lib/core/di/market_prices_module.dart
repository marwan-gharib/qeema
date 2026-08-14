import 'package:get_it/get_it.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_market_price_history_usecase.dart';
import 'package:qeema/features/market_prices/data/repositories/market_prices_repository_impl.dart';
import 'package:qeema/features/market_prices/domain/repositories/market_prices_repository.dart';
import 'package:qeema/features/market_prices/domain/usecases/get_market_price_range_usecase.dart';
import 'package:qeema/features/market_prices/domain/usecases/get_market_price_summaries_usecase.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_price_detail_cubit/market_price_detail_cubit.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_prices_list_cubit/market_prices_list_cubit.dart';

void initMarketPricesModule(GetIt getIt) {
  getIt.registerLazySingleton<MarketPricesRepository>(
    () => MarketPricesRepositoryImpl(
      getIt<GetAssetTypesUseCase>(),
      getIt<GetMarketPriceHistoryUseCase>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetMarketPriceSummariesUseCase(getIt<MarketPricesRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetMarketPriceRangeUseCase(getIt<MarketPricesRepository>()),
  );
  getIt.registerFactory(
    () => MarketPricesListCubit(getIt<GetMarketPriceSummariesUseCase>()),
  );
  getIt.registerFactoryParam<MarketPriceDetailCubit, String, void>(
    (assetTypeId, _) => MarketPriceDetailCubit(
      assetTypeId: assetTypeId,
      getAssetTypes: getIt<GetAssetTypesUseCase>(),
      getRange: getIt<GetMarketPriceRangeUseCase>(),
    ),
  );
}

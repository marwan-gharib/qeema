import 'package:get_it/get_it.dart';
import 'package:qeema/core/financial/asset_valuator.dart';
import 'package:qeema/core/local/cache/daos/asset_history_dao.dart';
import 'package:qeema/core/local/cache/daos/asset_types_dao.dart';
import 'package:qeema/core/local/cache/daos/assets_dao.dart';
import 'package:qeema/core/local/cache/daos/market_prices_dao.dart';
import 'package:qeema/core/network/network_info.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/network/supabase_query_executor.dart';
import 'package:qeema/features/assets/data/datasources/local/assets_local_datasource.dart';
import 'package:qeema/features/assets/data/datasources/remote/assets_remote_datasource.dart';
import 'package:qeema/features/assets/data/mappers/asset_mapper.dart';
import 'package:qeema/features/assets/data/repositories/assets_repository_impl.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:qeema/features/assets/domain/usecases/add_asset_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_history_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_valuation_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/soft_delete_asset_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/update_asset_usecase.dart';
import 'package:qeema/features/assets/presentation/blocs/assets_bloc/assets_bloc.dart';

Future<void> initAssetsModule(GetIt getIt) async {
  getIt.registerLazySingleton<AssetMapper>(() => AssetMapper());

  getIt.registerLazySingleton<AssetsRemoteDataSource>(
    () => AssetsRemoteDataSource(getIt<SupabaseQueryExecutor>()),
  );

  getIt.registerLazySingleton<AssetsLocalDataSource>(
    () => AssetsLocalDataSource(
      getIt<AssetsDao>(),
      getIt<MarketPricesDao>(),
      getIt<AssetTypesDao>(),
      getIt<AssetHistoryDao>(),
    ),
  );

  getIt.registerLazySingleton<AssetsRepository>(
    () => AssetsRepositoryImpl(
      getIt<AssetsRemoteDataSource>(),
      getIt<AssetsLocalDataSource>(),
      getIt<AssetMapper>(),
      getIt<NetworkInfo>(),
      getIt<SupabaseClientProvider>(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetAssetsUseCase(getIt<AssetsRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAssetTypesUseCase(getIt<AssetsRepository>()),
  );
  getIt.registerLazySingleton(() => AddAssetUseCase(getIt<AssetsRepository>()));
  getIt.registerLazySingleton(
    () => UpdateAssetUseCase(getIt<AssetsRepository>()),
  );
  getIt.registerLazySingleton(
    () => SoftDeleteAssetUseCase(getIt<AssetsRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAssetHistoryUseCase(getIt<AssetsRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAssetValuationUseCase(
      getIt<AssetValuator>(),
      getIt<MarketPricesDao>(),
    ),
  );

  getIt.registerFactory(
    () => AssetsBloc(
      getIt<GetAssetsUseCase>(),
      getIt<GetAssetTypesUseCase>(),
      getIt<AddAssetUseCase>(),
      getIt<UpdateAssetUseCase>(),
      getIt<SoftDeleteAssetUseCase>(),
    ),
  );
}

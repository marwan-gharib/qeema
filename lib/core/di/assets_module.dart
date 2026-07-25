import 'package:get_it/get_it.dart';
import 'package:qeema/core/local/cache/daos/assets_dao.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/features/assets/data/datasources/assets_remote_datasource.dart';
import 'package:qeema/features/assets/data/repositories/assets_repository_impl.dart';
import 'package:qeema/features/assets/domain/repositories/assets_repository.dart';
import 'package:qeema/features/assets/domain/usecases/add_asset_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/add_asset_cubit/add_asset_cubit.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_cubit.dart';

void initAssetsModule(GetIt getIt) {
  getIt.registerLazySingleton<AssetsRemoteDataSource>(
    () => AssetsRemoteDataSource(getIt<SupabaseClientProvider>()),
  );
  getIt.registerLazySingleton<AssetsRepository>(
    () => AssetsRepositoryImpl(
      getIt<AssetsRemoteDataSource>(),
      getIt<AssetsDao>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetAssetsUseCase(getIt<AssetsRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetAssetTypesUseCase(getIt<AssetsRepository>()),
  );
  getIt.registerLazySingleton(() => AddAssetUseCase(getIt<AssetsRepository>()));
  getIt.registerFactory(() => AssetsListCubit(getIt<GetAssetsUseCase>()));
  getIt.registerFactory(
    () =>
        AddAssetCubit(getIt<GetAssetTypesUseCase>(), getIt<AddAssetUseCase>()),
  );
}

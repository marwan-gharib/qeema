import 'package:get_it/get_it.dart';
import 'package:qeema/core/financial/currency_converter.dart';
import 'package:qeema/core/financial/inflation_calculator.dart';
import 'package:qeema/core/network/supabase_query_executor.dart';
import 'package:qeema/features/assets/domain/usecases/get_asset_types_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/home/data/datasources/home_remote_datasource.dart';
import 'package:qeema/features/home/data/repositories/home_repository_impl.dart';
import 'package:qeema/features/home/domain/repositories/home_repository.dart';
import 'package:qeema/features/home/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:qeema/features/home/presentation/cubits/home_cubit/home_cubit.dart';

void initHomeModule(GetIt getIt) {
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(getIt<SupabaseQueryExecutor>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      getIt<GetAssetsUseCase>(),
      getIt<GetAssetTypesUseCase>(),
      getIt<HomeRemoteDataSource>(),
      getIt<CurrencyConverter>(),
      getIt<InflationCalculator>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetDashboardSummaryUseCase(getIt<HomeRepository>()),
  );
  getIt.registerFactory(() => HomeCubit(getIt<GetDashboardSummaryUseCase>()));
}

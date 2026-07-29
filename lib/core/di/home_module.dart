import 'package:get_it/get_it.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/features/home/data/datasources/home_remote_datasource.dart';
import 'package:qeema/features/home/data/repositories/home_repository_impl.dart';
import 'package:qeema/features/home/domain/repositories/home_repository.dart';
import 'package:qeema/features/home/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:qeema/features/home/presentation/cubit/home_cubit.dart';

void initHomeModule(GetIt getIt) {
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(getIt<SupabaseClientProvider>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetDashboardSummaryUseCase(getIt()));
  getIt.registerFactory(() => HomeCubit(getIt()));
}

import 'package:get_it/get_it.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:qeema/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:qeema/features/auth/domain/repositories/auth_repository.dart';
import 'package:qeema/features/auth/domain/usecases/continue_as_guest_usecase.dart';
import 'package:qeema/features/auth/presentation/cubits/welcome_cubit/welcome_cubit.dart';

Future<void> initAuthModule(GetIt getIt) async {
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<SupabaseClientProvider>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => ContinueAsGuestUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory(() => WelcomeCubit(getIt<ContinueAsGuestUseCase>()));
}

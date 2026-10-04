import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/local/cache/cache_service.dart';
import 'package:qeema/core/local/secure/secure_storage_service.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/features/auth/domain/usecases/watch_auth_user_usecase.dart';
import 'package:qeema/features/settings/data/datasources/remote/account_remote_datasource.dart';
import 'package:qeema/features/settings/data/repositories/account_repository_impl.dart';
import 'package:qeema/features/settings/domain/repositories/account_repository.dart';
import 'package:qeema/features/settings/domain/usecases/delete_account_usecase.dart';
import 'package:qeema/features/settings/domain/usecases/logout_usecase.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/profile_header_cubit/profile_header_cubit.dart';

void initSettingsModule(GetIt getIt) {
  getIt.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSource(
      getIt<SupabaseClientProvider>(),
      getIt<GoogleSignIn>(),
    ),
  );
  getIt.registerLazySingleton<AccountRepository>(
    () => AccountRepositoryImpl(
      getIt<AccountRemoteDataSource>(),
      getIt<AppDatabase>(),
      getIt<SecureStorageService>(),
      getIt<CacheService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => DeleteAccountUseCase(getIt<AccountRepository>()),
  );
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AccountRepository>()));
  getIt.registerFactory(
    () => DeleteAccountCubit(getIt<DeleteAccountUseCase>()),
  );
  getIt.registerFactory(
    () => LogoutCubit(getIt<LogoutUseCase>(), getIt<AccountRepository>()),
  );
  getIt.registerFactory(
    () => ProfileHeaderCubit(getIt<WatchAuthUserUseCase>()),
  );
}

import 'package:get_it/get_it.dart';
import 'package:qeema/core/local/cache/cache_service.dart';
import 'package:qeema/core/services/device_auth_service.dart';
import 'package:qeema/core/services/window_security_service.dart';
import 'package:qeema/features/app_lock/data/datasources/local/app_lock_local_datasource.dart';
import 'package:qeema/features/app_lock/data/repositories/app_lock_repository_impl.dart';
import 'package:qeema/features/app_lock/domain/repositories/app_lock_repository.dart';
import 'package:qeema/features/app_lock/domain/usecases/authenticate_device_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/check_device_lock_available_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/get_app_lock_enabled_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/set_app_lock_enabled_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/set_recents_preview_hidden_usecase.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_cubit.dart';

void initAppLockModule(GetIt getIt) {
  getIt.registerLazySingleton<DeviceAuthService>(() => DeviceAuthService());
  getIt.registerLazySingleton<WindowSecurityService>(
    () => WindowSecurityService(),
  );
  getIt.registerLazySingleton<AppLockLocalDataSource>(
    () => AppLockLocalDataSource(getIt<CacheService>()),
  );
  getIt.registerLazySingleton<AppLockRepository>(
    () => AppLockRepositoryImpl(
      getIt<AppLockLocalDataSource>(),
      getIt<DeviceAuthService>(),
      getIt<WindowSecurityService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetAppLockEnabledUseCase(getIt<AppLockRepository>()),
  );
  getIt.registerLazySingleton(
    () => SetAppLockEnabledUseCase(getIt<AppLockRepository>()),
  );
  getIt.registerLazySingleton(
    () => CheckDeviceLockAvailableUseCase(getIt<AppLockRepository>()),
  );
  getIt.registerLazySingleton(
    () => AuthenticateDeviceUseCase(getIt<AppLockRepository>()),
  );
  getIt.registerLazySingleton(
    () => SetRecentsPreviewHiddenUseCase(getIt<AppLockRepository>()),
  );
  // Single state owner for the lock gate, consumed by the router redirect
  // and the lifecycle observer — a singleton, like LocaleCubit/ThemeCubit.
  getIt.registerLazySingleton<AppLockCubit>(
    () => AppLockCubit(
      getIt<GetAppLockEnabledUseCase>(),
      getIt<CheckDeviceLockAvailableUseCase>(),
      getIt<AuthenticateDeviceUseCase>(),
      getIt<SetRecentsPreviewHiddenUseCase>(),
    ),
  );
  getIt.registerFactory<AppLockSettingsCubit>(
    () => AppLockSettingsCubit(
      getIt<GetAppLockEnabledUseCase>(),
      getIt<SetAppLockEnabledUseCase>(),
      getIt<CheckDeviceLockAvailableUseCase>(),
      getIt<AuthenticateDeviceUseCase>(),
      getIt<AppLockCubit>(),
    ),
  );
}

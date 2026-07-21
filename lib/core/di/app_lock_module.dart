import 'package:get_it/get_it.dart';
import 'package:qeema/core/services/app_lock_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';

void initAppLockModule(GetIt getIt) {
  getIt.registerLazySingleton<AppLockService>(
    () => AppLockService(getIt(), getIt<BiometricAuthService>()),
  );

  getIt.registerFactory<LockCubit>(
    () => LockCubit(getIt<BiometricAuthService>()),
  );
}

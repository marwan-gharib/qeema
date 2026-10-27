import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_cubit.dart';

import '../../../../helpers/app_lock_mocks.dart';

/// Builds an [AppLockSettingsCubit] with its mocks and a [SpyAppLockCubit].
class AppLockSettingsCubitHarness {
  AppLockSettingsCubitHarness._({
    required this.getEnabled,
    required this.setEnabled,
    required this.checkAvailable,
    required this.authenticate,
    required this.appLock,
    required this.cubit,
  });

  static AppLockSettingsCubitHarness create() {
    final getEnabled = MockGetAppLockEnabledUseCase();
    final setEnabled = MockSetAppLockEnabledUseCase();
    final checkAvailable = MockCheckDeviceLockAvailableUseCase();
    final authenticate = MockAuthenticateDeviceUseCase();
    final appLock = SpyAppLockCubit(
      getEnabled,
      checkAvailable,
      authenticate,
      MockSetRecentsPreviewHiddenUseCase(),
    );
    final cubit = AppLockSettingsCubit(
      getEnabled,
      setEnabled,
      checkAvailable,
      authenticate,
      appLock,
    );
    return AppLockSettingsCubitHarness._(
      getEnabled: getEnabled,
      setEnabled: setEnabled,
      checkAvailable: checkAvailable,
      authenticate: authenticate,
      appLock: appLock,
      cubit: cubit,
    );
  }

  final MockGetAppLockEnabledUseCase getEnabled;
  final MockSetAppLockEnabledUseCase setEnabled;
  final MockCheckDeviceLockAvailableUseCase checkAvailable;
  final MockAuthenticateDeviceUseCase authenticate;
  final SpyAppLockCubit appLock;
  final AppLockSettingsCubit cubit;

  void dispose() {
    cubit.close();
    appLock.close();
  }
}

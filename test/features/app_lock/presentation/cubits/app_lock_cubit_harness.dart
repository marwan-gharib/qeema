import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';

import '../../../../helpers/app_lock_mocks.dart';

/// Builds an [AppLockCubit] with its four mock usecases for the cubit tests.
class AppLockCubitHarness {
  AppLockCubitHarness._({
    required this.getEnabled,
    required this.checkAvailable,
    required this.authenticate,
    required this.setRecentsPreviewHidden,
    required this.cubit,
  });

  static Future<AppLockCubitHarness> create() async {
    final getEnabled = MockGetAppLockEnabledUseCase();
    final checkAvailable = MockCheckDeviceLockAvailableUseCase();
    final authenticate = MockAuthenticateDeviceUseCase();
    final setRecentsPreviewHidden = MockSetRecentsPreviewHiddenUseCase();
    final cubit = AppLockCubit(
      getEnabled,
      checkAvailable,
      authenticate,
      setRecentsPreviewHidden,
    );
    return AppLockCubitHarness._(
      getEnabled: getEnabled,
      checkAvailable: checkAvailable,
      authenticate: authenticate,
      setRecentsPreviewHidden: setRecentsPreviewHidden,
      cubit: cubit,
    );
  }

  final MockGetAppLockEnabledUseCase getEnabled;
  final MockCheckDeviceLockAvailableUseCase checkAvailable;
  final MockAuthenticateDeviceUseCase authenticate;
  final MockSetRecentsPreviewHiddenUseCase setRecentsPreviewHidden;
  final AppLockCubit cubit;

  void dispose() {
    cubit.close();
  }
}

import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/services/device_auth_service.dart';
import 'package:qeema/core/services/window_security_service.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/data/datasources/local/app_lock_local_datasource.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/domain/repositories/app_lock_repository.dart';

final class AppLockRepositoryImpl implements AppLockRepository {
  const AppLockRepositoryImpl(
    this.appLockLocalDataSource,
    this._deviceAuth,
    this._windowSecurity,
  );
  final AppLockLocalDataSource appLockLocalDataSource;
  final DeviceAuthService _deviceAuth;
  final WindowSecurityService _windowSecurity;

  @override
  Future<ApiResult<bool>> isEnabled() async {
    try {
      return Success(await appLockLocalDataSource.isEnabled());
    } catch (e) {
      return const ResultFailure(CacheFailure());
    }
  }

  @override
  Future<ApiResult<void>> setEnabled(bool enabled) async {
    try {
      await appLockLocalDataSource.setEnabled(enabled);
      return const Success(null);
    } catch (e) {
      return const ResultFailure(CacheFailure());
    }
  }

  @override
  Future<ApiResult<bool>> isDeviceLockAvailable() =>
      _deviceAuth.isDeviceLockAvailable();

  @override
  Future<ApiResult<AppLockStatus>> authenticate(String reason) async {
    final result = await _deviceAuth.authenticate(reason: reason);
    return result.fold(
      onSuccess: (_) => const Success(AppLockStatus.authenticated),
      // Cancelled/lockout/no-lock outcomes are expected results of the OS
      // prompt, not errors; only unexpected failures propagate as failures.
      onFailure: (failure) => switch (failure) {
        LocalAuthCancelledFailure() => const Success(AppLockStatus.failed),
        LocalAuthLockoutFailure() => const Success(AppLockStatus.lockedOut),
        // The only outcomes that may open the gate: the OS itself reported
        // that no credential is set, or it is not available (per plan §3).
        LocalAuthNoCredentialsFailure() || LocalAuthUnavailableFailure() =>
          const Success(AppLockStatus.notRequired),
        _ => ResultFailure<AppLockStatus>(failure),
      },
    );
  }

  @override
  Future<ApiResult<void>> setRecentsPreviewHidden(bool hidden) =>
      _windowSecurity.setRecentsPreviewHidden(hidden: hidden);
}

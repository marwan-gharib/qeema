import 'package:local_auth/local_auth.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/logger.dart';

class BiometricAuthService {
  BiometricAuthService(this._localAuth);
  final LocalAuthentication _localAuth;

  Future<ApiResult<bool>> authenticate({
    required String localizedReason,
  }) async {
    Logger.info(
      '[Biometric] authenticate(localizedReason: "$localizedReason")',
    );
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      Logger.info('[Biometric] authenticate → Success($authenticated)');
      return Success(authenticated);
    } on LocalAuthException catch (e) {
      Logger.warning(
        '[Biometric] authenticate → ${e.runtimeType}(code: ${e.code})',
      );
      return ResultFailure(_mapExceptionToFailure(e));
    }
  }

  Future<bool> get isDeviceSupported async {
    try {
      final result = await _localAuth.isDeviceSupported();
      Logger.info('[Biometric] isDeviceSupported → $result');
      return result;
    } catch (_) {
      Logger.warning(
        '[Biometric] isDeviceSupported → exception, returning false',
      );
      return false;
    }
  }

  Future<bool> get canCheckBiometrics async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  Failure _mapExceptionToFailure(LocalAuthException e) {
    return switch (e.code) {
      LocalAuthExceptionCode.userCanceled ||
      LocalAuthExceptionCode.systemCanceled ||
      LocalAuthExceptionCode.userRequestedFallback ||
      LocalAuthExceptionCode.timeout => const LocalAuthCancelledFailure(),
      LocalAuthExceptionCode.temporaryLockout ||
      LocalAuthExceptionCode.biometricLockout =>
        const LocalAuthLockoutFailure(),
      LocalAuthExceptionCode.noCredentialsSet ||
      LocalAuthExceptionCode.noBiometricsEnrolled =>
        const LocalAuthNoCredentialsFailure(),
      LocalAuthExceptionCode.noBiometricHardware ||
      LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable ||
      LocalAuthExceptionCode.uiUnavailable =>
        const LocalAuthUnavailableFailure(),
      _ => const LocalAuthUnknownFailure(),
    };
  }
}

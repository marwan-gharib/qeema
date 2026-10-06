import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';

class DeviceAuthService {
  DeviceAuthService({LocalAuthentication? localAuthentication})
    : _localAuth = localAuthentication ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  /// `isDeviceSupported()` is the plugin's own definition of "the OS can prompt
  /// for a device credential": Android reports
  /// `isDeviceSecure() || canAuthenticateWithBiometrics()` and iOS reports
  /// `canEvaluatePolicy(.deviceOwnerAuthentication)`, so it already accounts
  /// for a PIN/pattern/password set without enrolled biometrics.
  ///
  /// This deliberately no longer assumes availability. Guessing "true" made
  /// the "no device lock" state in Settings unreachable and pushed the decision
  /// onto `authenticate()`, whose failure codes cannot distinguish "no lock"
  /// from "no working sensor".
  Future<ApiResult<bool>> isDeviceLockAvailable() async {
    try {
      return Success(await _localAuth.isDeviceSupported());
    } on LocalAuthException catch (e) {
      return ResultFailure(_mapException(e));
    } on PlatformException catch (e) {
      return ResultFailure(_mapPlatformException(e));
    } on Exception catch (e) {
      return ResultFailure(LocalAuthUnknownFailure(e.toString()));
    }
  }

  Future<ApiResult<void>> authenticate({required String reason}) async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      if (authenticated) {
        return const Success(null);
      }
      return const ResultFailure(LocalAuthCancelledFailure());
    } on LocalAuthException catch (e) {
      return ResultFailure(_mapException(e));
    } on PlatformException catch (e) {
      return ResultFailure(_mapPlatformException(e));
    } on Exception catch (e) {
      return ResultFailure(LocalAuthUnknownFailure(e.toString()));
    }
  }

  /// Only a genuine "the OS has no credential set" code may be reported as
  /// [LocalAuthNoCredentialsFailure]; every other non-authentication outcome
  /// fails closed and the app stays locked.
  Failure _mapException(
    LocalAuthException exception,
  ) => switch (exception.code) {
    LocalAuthExceptionCode.userCanceled ||
    LocalAuthExceptionCode.systemCanceled ||
    LocalAuthExceptionCode.timeout ||
    LocalAuthExceptionCode.userRequestedFallback ||
    LocalAuthExceptionCode.authInProgress => const LocalAuthCancelledFailure(),
    LocalAuthExceptionCode.temporaryLockout ||
    LocalAuthExceptionCode.biometricLockout => const LocalAuthLockoutFailure(),
    LocalAuthExceptionCode.noCredentialsSet ||
    LocalAuthExceptionCode.noBiometricsEnrolled =>
      const LocalAuthNoCredentialsFailure(),
    LocalAuthExceptionCode.noBiometricHardware ||
    LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable =>
      const LocalAuthUnavailableFailure(),
    // uiUnavailable, deviceError, unknownError and any code added in a
    // future plugin version: fail closed, never open on surprise errors.
    _ => const LocalAuthUnknownFailure(),
  };

  Failure _mapPlatformException(
    PlatformException exception,
  ) => switch (exception.code) {
    'passcodeNotSet' || 'NotEnrolled' => const LocalAuthNoCredentialsFailure(),
    'NotAvailable' => const LocalAuthUnavailableFailure(),
    'LockedOut' || 'PermanentlyLockedOut' => const LocalAuthLockoutFailure(),
    'UserCanceled' ||
    'SystemCanceled' ||
    'Timeout' ||
    'AuthInProgress' => const LocalAuthCancelledFailure(),
    _ => const LocalAuthUnknownFailure(),
  };
}

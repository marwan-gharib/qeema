import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/extensions/api_result_extensions.dart';
import 'package:qeema/core/services/device_auth_service.dart';
import 'package:qeema/core/utils/api_result.dart';

class _FakeLocalAuthPlatform extends LocalAuthPlatform {
  bool deviceSupported = true;
  bool authenticateResult = true;
  Object? errorToThrow;
  String? lastLocalizedReason;
  AuthenticationOptions? lastOptions;
  List<BiometricType> availableBiometrics = [];
  VoidCallback? onGetEnrolledBiometrics;

  @override
  Future<bool> isDeviceSupported() async {
    final error = errorToThrow;
    if (error != null) throw error;
    return deviceSupported;
  }

  @override
  Future<List<BiometricType>> getEnrolledBiometrics() async {
    onGetEnrolledBiometrics?.call();
    final error = errorToThrow;
    if (error != null) throw error;
    return availableBiometrics;
  }

  @override
  Future<bool> authenticate({
    required String localizedReason,
    required Iterable<AuthMessages> authMessages,
    AuthenticationOptions options = const AuthenticationOptions(),
  }) async {
    lastLocalizedReason = localizedReason;
    lastOptions = options;
    final error = errorToThrow;
    if (error != null) throw error;
    return authenticateResult;
  }
}

void main() {
  late _FakeLocalAuthPlatform platform;
  late DeviceAuthService service;
  late LocalAuthPlatform originalPlatform;

  setUp(() {
    originalPlatform = LocalAuthPlatform.instance;
    platform = _FakeLocalAuthPlatform();
    LocalAuthPlatform.instance = platform;
    service = DeviceAuthService();
  });

  tearDown(() {
    LocalAuthPlatform.instance = originalPlatform;
  });

  group('isDeviceLockAvailable', () {
    test('returns true when the OS reports a lock it can prompt for', () async {
      platform.deviceSupported = true;
      platform.availableBiometrics = [BiometricType.fingerprint];

      final result = await service.isDeviceLockAvailable();

      expect(result.dataOrNull, isTrue);
    });

    test(
      'returns true for a PIN/pattern-only device with no enrolled biometrics',
      () async {
        platform.deviceSupported = true;
        platform.availableBiometrics = [];

        final result = await service.isDeviceLockAvailable();

        expect(result.dataOrNull, isTrue);
      },
    );

    test('returns false when the OS reports no lock to prompt for', () async {
      platform.deviceSupported = false;
      platform.availableBiometrics = [];

      final result = await service.isDeviceLockAvailable();

      expect(result.dataOrNull, isFalse);
    });

    test('does not consult enrolled biometrics', () async {
      platform.deviceSupported = true;
      var enrolledCalled = false;
      platform.onGetEnrolledBiometrics = () => enrolledCalled = true;

      await service.isDeviceLockAvailable();

      expect(enrolledCalled, isFalse);
    });

    test('maps a plugin exception to LocalAuthUnknownFailure', () async {
      platform.errorToThrow = const LocalAuthException(
        code: LocalAuthExceptionCode.deviceError,
      );

      final result = await service.isDeviceLockAvailable();

      expect(result.failureOrNull, isA<LocalAuthUnknownFailure>());
    });

    test('maps a generic error to LocalAuthUnknownFailure', () async {
      platform.errorToThrow = Exception('channel broken');

      final result = await service.isDeviceLockAvailable();

      expect(result.failureOrNull, isA<LocalAuthUnknownFailure>());
    });
  });

  group('authenticate', () {
    test('returns Success when the OS reports true', () async {
      final result = await service.authenticate(reason: 'Unlock reason');

      expect(result, isA<Success<void>>());
      expect(platform.lastLocalizedReason, 'Unlock reason');
      expect(platform.lastOptions?.biometricOnly, isFalse);
      expect(platform.lastOptions?.stickyAuth, isTrue);
    });

    test(
      'returns LocalAuthCancelledFailure when the OS reports false',
      () async {
        platform.authenticateResult = false;

        final result = await service.authenticate(reason: 'Unlock reason');

        expect(result.failureOrNull, isA<LocalAuthCancelledFailure>());
      },
    );

    test('maps userCanceled to LocalAuthCancelledFailure', () async {
      platform.errorToThrow = const LocalAuthException(
        code: LocalAuthExceptionCode.userCanceled,
      );

      final result = await service.authenticate(reason: 'Unlock reason');

      expect(result.failureOrNull, isA<LocalAuthCancelledFailure>());
    });

    test('maps systemCanceled to LocalAuthCancelledFailure', () async {
      platform.errorToThrow = const LocalAuthException(
        code: LocalAuthExceptionCode.systemCanceled,
      );

      final result = await service.authenticate(reason: 'Unlock reason');

      expect(result.failureOrNull, isA<LocalAuthCancelledFailure>());
    });

    test('maps temporaryLockout to LocalAuthLockoutFailure', () async {
      platform.errorToThrow = const LocalAuthException(
        code: LocalAuthExceptionCode.temporaryLockout,
      );

      final result = await service.authenticate(reason: 'Unlock reason');

      expect(result.failureOrNull, isA<LocalAuthLockoutFailure>());
    });

    test('maps noCredentialsSet to LocalAuthNoCredentialsFailure', () async {
      platform.errorToThrow = const LocalAuthException(
        code: LocalAuthExceptionCode.noCredentialsSet,
      );

      final result = await service.authenticate(reason: 'Unlock reason');

      expect(result.failureOrNull, isA<LocalAuthNoCredentialsFailure>());
    });

    test(
      'maps missing biometric hardware to LocalAuthUnavailableFailure',
      () async {
        platform.errorToThrow = const LocalAuthException(
          code: LocalAuthExceptionCode.noBiometricHardware,
        );

        final result = await service.authenticate(reason: 'Unlock reason');

        expect(result.failureOrNull, isA<LocalAuthUnavailableFailure>());
      },
    );

    test(
      'falls back to LocalAuthUnknownFailure for unexpected codes',
      () async {
        platform.errorToThrow = const LocalAuthException(
          code: LocalAuthExceptionCode.unknownError,
        );

        final result = await service.authenticate(reason: 'Unlock reason');

        expect(result.failureOrNull, isA<LocalAuthUnknownFailure>());
      },
    );

    test('maps legacy PlatformException codes from 2.x plugins', () async {
      platform.errorToThrow = PlatformException(code: 'LockedOut');

      final result = await service.authenticate(reason: 'Unlock reason');

      expect(result.failureOrNull, isA<LocalAuthLockoutFailure>());
    });

    test('maps an unknown PlatformException code to unknown failure', () async {
      platform.errorToThrow = PlatformException(code: 'SomethingNew');

      final result = await service.authenticate(reason: 'Unlock reason');

      expect(result.failureOrNull, isA<LocalAuthUnknownFailure>());
    });
  });
}

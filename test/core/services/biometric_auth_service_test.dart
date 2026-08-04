import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/utils/api_result.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockLocalAuthentication mockLocalAuth;
  late BiometricAuthService service;

  setUp(() {
    mockLocalAuth = MockLocalAuthentication();
    service = BiometricAuthService(mockLocalAuth);
  });

  group('authenticate', () {
    test('returns Success on successful authentication', () async {
      mockLocalAuth.authenticateResult = true;

      final result = await service.authenticate(localizedReason: 'Test reason');

      expect(result, isA<Success<void>>());
    });

    test(
      'returns LocalAuthUnknownFailure when authentication is rejected',
      () async {
        mockLocalAuth.authenticateResult = false;

        final result = await service.authenticate(
          localizedReason: 'Test reason',
        );

        expect(result, isA<ResultFailure<void>>());
        expect(
          (result as ResultFailure<void>).failure,
          isA<LocalAuthUnknownFailure>(),
        );
      },
    );

    test('returns LocalAuthCancelledFailure on user cancel', () async {
      mockLocalAuth.throwException = true;
      mockLocalAuth.exceptionToThrow = const LocalAuthException(
        code: LocalAuthExceptionCode.userCanceled,
      );

      final result = await service.authenticate(localizedReason: 'Test reason');

      expect(result, isA<ResultFailure<void>>());
      expect(
        (result as ResultFailure<void>).failure,
        isA<LocalAuthCancelledFailure>(),
      );
    });

    test('returns LocalAuthCancelledFailure on system cancel', () async {
      mockLocalAuth.throwException = true;
      mockLocalAuth.exceptionToThrow = const LocalAuthException(
        code: LocalAuthExceptionCode.systemCanceled,
      );

      final result = await service.authenticate(localizedReason: 'Test reason');

      expect(result, isA<ResultFailure<void>>());
      expect(
        (result as ResultFailure<void>).failure,
        isA<LocalAuthCancelledFailure>(),
      );
    });

    test('returns LocalAuthLockoutFailure on temporary lockout', () async {
      mockLocalAuth.throwException = true;
      mockLocalAuth.exceptionToThrow = const LocalAuthException(
        code: LocalAuthExceptionCode.temporaryLockout,
      );

      final result = await service.authenticate(localizedReason: 'Test reason');

      expect(result, isA<ResultFailure<void>>());
      expect(
        (result as ResultFailure<void>).failure,
        isA<LocalAuthLockoutFailure>(),
      );
    });

    test('returns LocalAuthLockoutFailure on biometric lockout', () async {
      mockLocalAuth.throwException = true;
      mockLocalAuth.exceptionToThrow = const LocalAuthException(
        code: LocalAuthExceptionCode.biometricLockout,
      );

      final result = await service.authenticate(localizedReason: 'Test reason');

      expect(result, isA<ResultFailure<void>>());
      expect(
        (result as ResultFailure<void>).failure,
        isA<LocalAuthLockoutFailure>(),
      );
    });

    test('returns LocalAuthNoCredentialsFailure on no credentials', () async {
      mockLocalAuth.throwException = true;
      mockLocalAuth.exceptionToThrow = const LocalAuthException(
        code: LocalAuthExceptionCode.noCredentialsSet,
      );

      final result = await service.authenticate(localizedReason: 'Test reason');

      expect(result, isA<ResultFailure<void>>());
      expect(
        (result as ResultFailure<void>).failure,
        isA<LocalAuthNoCredentialsFailure>(),
      );
    });

    test(
      'returns LocalAuthUnavailableFailure on no biometric hardware',
      () async {
        mockLocalAuth.throwException = true;
        mockLocalAuth.exceptionToThrow = const LocalAuthException(
          code: LocalAuthExceptionCode.noBiometricHardware,
        );

        final result = await service.authenticate(
          localizedReason: 'Test reason',
        );

        expect(result, isA<ResultFailure<void>>());
        expect(
          (result as ResultFailure<void>).failure,
          isA<LocalAuthUnavailableFailure>(),
        );
      },
    );

    test('returns LocalAuthUnknownFailure on unknown error', () async {
      mockLocalAuth.throwException = true;
      mockLocalAuth.exceptionToThrow = const LocalAuthException(
        code: LocalAuthExceptionCode.unknownError,
      );

      final result = await service.authenticate(localizedReason: 'Test reason');

      expect(result, isA<ResultFailure<void>>());
      expect(
        (result as ResultFailure<void>).failure,
        isA<LocalAuthUnknownFailure>(),
      );
    });
  });

  group('isDeviceSupported', () {
    test('returns true when device is supported', () async {
      mockLocalAuth.isDeviceSupportedResult = true;

      final result = await service.isDeviceSupported;

      expect(result, true);
    });

    test('returns false when device is not supported', () async {
      mockLocalAuth.isDeviceSupportedResult = false;

      final result = await service.isDeviceSupported;

      expect(result, false);
    });
  });

  group('canCheckBiometrics', () {
    test('returns true when biometrics can be checked', () async {
      mockLocalAuth.canCheckBiometricsResult = true;

      final result = await service.canCheckBiometrics;

      expect(result, true);
    });

    test('returns false when biometrics cannot be checked', () async {
      mockLocalAuth.canCheckBiometricsResult = false;

      final result = await service.canCheckBiometrics;

      expect(result, false);
    });
  });
}

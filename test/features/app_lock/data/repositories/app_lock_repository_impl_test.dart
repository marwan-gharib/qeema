import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/extensions/api_result_extensions.dart';
import 'package:qeema/core/services/device_auth_service.dart';
import 'package:qeema/core/services/window_security_service.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/data/datasources/local/app_lock_local_datasource.dart';
import 'package:qeema/features/app_lock/data/repositories/app_lock_repository_impl.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/domain/repositories/app_lock_repository.dart';

import '../../../../helpers/mocks.dart';

class _FakeDeviceAuthService implements DeviceAuthService {
  ApiResult<bool> availabilityResult = const Success(true);
  ApiResult<void> authResult = const Success(null);
  String? lastReason;

  @override
  Future<ApiResult<bool>> isDeviceLockAvailable() async => availabilityResult;

  @override
  Future<ApiResult<void>> authenticate({required String reason}) async {
    lastReason = reason;
    return authResult;
  }
}

class _FakeWindowSecurityService implements WindowSecurityService {
  final List<bool> hiddenCalls = [];
  ApiResult<void> result = const Success(null);

  @override
  Future<ApiResult<void>> setRecentsPreviewHidden({
    required bool hidden,
  }) async {
    hiddenCalls.add(hidden);
    return result;
  }
}

void main() {
  late MockCacheService cache;
  late AppLockLocalDataSource datasource;
  late _FakeDeviceAuthService deviceAuth;
  late _FakeWindowSecurityService windowSecurity;
  late AppLockRepository repository;

  setUp(() {
    cache = MockCacheService();
    datasource = AppLockLocalDataSource(cache);
    deviceAuth = _FakeDeviceAuthService();
    windowSecurity = _FakeWindowSecurityService();
    repository = AppLockRepositoryImpl(datasource, deviceAuth, windowSecurity);
  });

  group('isEnabled', () {
    test('defaults to true when nothing is stored', () async {
      final result = await repository.isEnabled();

      expect(result.dataOrNull, isTrue);
    });

    test('returns the stored value', () async {
      await datasource.setEnabled(false);

      final result = await repository.isEnabled();

      expect(result.dataOrNull, isFalse);
    });

    test('returns CacheFailure when the cache read throws', () async {
      cache.shouldThrowOnRead = true;

      final result = await repository.isEnabled();

      expect(result.failureOrNull, isA<CacheFailure>());
    });

    test('returns CacheFailure when the cache write throws', () async {
      cache.shouldThrowOnWrite = true;

      final result = await repository.setEnabled(true);

      expect(result.failureOrNull, isA<CacheFailure>());
    });
  });

  group('isDeviceLockAvailable', () {
    test('delegates to the device auth service', () async {
      deviceAuth.availabilityResult = const Success(false);

      final result = await repository.isDeviceLockAvailable();

      expect(result.dataOrNull, isFalse);
    });

    test('propagates a failure unchanged', () async {
      deviceAuth.availabilityResult = const ResultFailure(
        LocalAuthUnknownFailure(),
      );

      final result = await repository.isDeviceLockAvailable();

      expect(result.failureOrNull, isA<LocalAuthUnknownFailure>());
    });
  });

  group('authenticate', () {
    test('maps a successful prompt to authenticated', () async {
      final result = await repository.authenticate('reason');

      expect(deviceAuth.lastReason, 'reason');
      expect(result.dataOrNull, AppLockStatus.authenticated);
    });

    test('maps cancellation to failed', () async {
      deviceAuth.authResult = const ResultFailure(LocalAuthCancelledFailure());

      final result = await repository.authenticate('reason');

      expect(result.dataOrNull, AppLockStatus.failed);
    });

    test('maps lockout to lockedOut', () async {
      deviceAuth.authResult = const ResultFailure(LocalAuthLockoutFailure());

      final result = await repository.authenticate('reason');

      expect(result.dataOrNull, AppLockStatus.lockedOut);
    });

    test('maps no-credentials to notRequired', () async {
      deviceAuth.authResult = const ResultFailure(
        LocalAuthNoCredentialsFailure(),
      );

      final result = await repository.authenticate('reason');

      expect(result.dataOrNull, AppLockStatus.notRequired);
    });

    test('maps an unavailable sensor to notRequired (per plan §3)', () async {
      deviceAuth.authResult = const ResultFailure(
        LocalAuthUnavailableFailure(),
      );

      final result = await repository.authenticate('reason');

      expect(result.dataOrNull, AppLockStatus.notRequired);
    });

    test('propagates unknown failures instead of opening the gate', () async {
      deviceAuth.authResult = const ResultFailure(LocalAuthUnknownFailure());

      final result = await repository.authenticate('reason');

      expect(result.failureOrNull, isA<LocalAuthUnknownFailure>());
    });
  });

  group('setRecentsPreviewHidden', () {
    test('forwards the flag to the window security service', () async {
      final result = await repository.setRecentsPreviewHidden(true);

      expect(windowSecurity.hiddenCalls, [true]);
      expect(result, isA<Success<void>>());
    });

    test('does not translate a service failure', () async {
      windowSecurity.result = const ResultFailure(UnknownFailure('nope'));

      final result = await repository.setRecentsPreviewHidden(false);

      expect(result.failureOrNull, isA<UnknownFailure>());
    });
  });
}

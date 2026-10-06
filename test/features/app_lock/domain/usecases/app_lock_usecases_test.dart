import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/extensions/api_result_extensions.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/domain/repositories/app_lock_repository.dart';
import 'package:qeema/features/app_lock/domain/usecases/authenticate_device_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/check_device_lock_available_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/get_app_lock_enabled_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/set_app_lock_enabled_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/set_recents_preview_hidden_usecase.dart';

class _MockAppLockRepository implements AppLockRepository {
  ApiResult<bool> boolResult = const Success(true);
  ApiResult<void> voidResult = const Success(null);
  ApiResult<AppLockStatus> statusResult = const Success(
    AppLockStatus.authenticated,
  );
  bool? lastEnabled;
  bool? lastHidden;
  String? lastReason;

  @override
  Future<ApiResult<bool>> isEnabled() async => boolResult;

  @override
  Future<ApiResult<void>> setEnabled(bool enabled) async {
    lastEnabled = enabled;
    return voidResult;
  }

  @override
  Future<ApiResult<bool>> isDeviceLockAvailable() async => boolResult;

  @override
  Future<ApiResult<AppLockStatus>> authenticate(String reason) async {
    lastReason = reason;
    return statusResult;
  }

  @override
  Future<ApiResult<void>> setRecentsPreviewHidden(bool hidden) async {
    lastHidden = hidden;
    return voidResult;
  }
}

void main() {
  group('GetAppLockEnabledUseCase', () {
    test('returns the repository result', () async {
      final repository = _MockAppLockRepository()
        ..boolResult = const Success(false);
      final usecase = GetAppLockEnabledUseCase(repository);

      final result = await usecase();

      expect(result, isA<Success<bool>>());
      expect(result.dataOrNull, isFalse);
    });
  });

  group('SetAppLockEnabledUseCase', () {
    test('passes the flag to the repository', () async {
      final repository = _MockAppLockRepository();
      final usecase = SetAppLockEnabledUseCase(repository);

      final result = await usecase(false);

      expect(repository.lastEnabled, isFalse);
      expect(result, isA<Success<void>>());
    });
  });

  group('CheckDeviceLockAvailableUseCase', () {
    test('returns the repository result', () async {
      final repository = _MockAppLockRepository();
      final usecase = CheckDeviceLockAvailableUseCase(repository);

      final result = await usecase();

      expect(result.dataOrNull, isTrue);
    });
  });

  group('AuthenticateDeviceUseCase', () {
    test('passes the reason to the repository', () async {
      final repository = _MockAppLockRepository();
      final usecase = AuthenticateDeviceUseCase(repository);

      final result = await usecase('Unlock reason');

      expect(repository.lastReason, 'Unlock reason');
      expect(result.dataOrNull, AppLockStatus.authenticated);
    });
  });

  group('SetRecentsPreviewHiddenUseCase', () {
    test('passes the flag to the repository', () async {
      final repository = _MockAppLockRepository();
      final usecase = SetRecentsPreviewHiddenUseCase(repository);

      final result = await usecase(true);

      expect(repository.lastHidden, isTrue);
      expect(result, isA<Success<void>>());
    });
  });
}

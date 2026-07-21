import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qeema/core/services/app_lock_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/features/settings/presentation/cubits/settings_cubit/settings_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/settings_cubit/settings_state.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockLocalAuthentication mockLocalAuth;
  late MockSecureStorageService mockStorage;
  late BiometricAuthService biometricAuthService;
  late AppLockService appLockService;
  late SettingsCubit cubit;

  setUp(() {
    mockLocalAuth = MockLocalAuthentication();
    mockStorage = MockSecureStorageService();
    biometricAuthService = BiometricAuthService(mockLocalAuth);
    appLockService = AppLockService(mockStorage, biometricAuthService);
    cubit = SettingsCubit(appLockService, biometricAuthService);
  });

  tearDown(() {
    cubit.close();
  });

  group('load', () {
    test('emits SettingsLoadSuccess with correct initial values', () async {
      final future = expectLater(
        cubit.stream,
        emits(isA<SettingsLoadSuccess>()),
      );
      unawaited(cubit.load());
      await future;

      expect((cubit.state as SettingsLoadSuccess).isLockEnabled, true);
      expect((cubit.state as SettingsLoadSuccess).isDeviceSupported, true);
    });

    test('emits SettingsLoadSuccess with enabled when flag is set', () async {
      await mockStorage.write(key: 'is_local_auth_enabled', value: 'true');

      unawaited(cubit.load());
      await expectLater(
        cubit.stream,
        emits(predicate<SettingsLoadSuccess>((s) => s.isLockEnabled == true)),
      );
    });
  });

  group('toggleLock - enable', () {
    test('persists enabled flag on successful auth', () async {
      await cubit.load();
      await Future(() {});

      await cubit.toggleLock(true);
      await Future(() {});

      const key = 'is_local_auth_enabled';
      final saved = await mockStorage.read(key: key);
      expect(saved, 'true');
      expect(cubit.state, isA<SettingsLoadSuccess>());
      expect((cubit.state as SettingsLoadSuccess).isLockEnabled, true);
    });

    test('does NOT persist flag when auth fails', () async {
      await mockStorage.write(key: 'is_local_auth_enabled', value: 'false');
      mockLocalAuth.authenticateResult = false;
      await cubit.load();
      await Future(() {});

      await cubit.toggleLock(true);
      await Future(() {});

      const key = 'is_local_auth_enabled';
      final saved = await mockStorage.read(key: key);
      expect(saved, 'false');
      expect(cubit.state, isA<SettingsToggleError>());
    });

    test('does NOT persist flag when auth is cancelled', () async {
      await mockStorage.write(key: 'is_local_auth_enabled', value: 'false');
      mockLocalAuth.throwException = true;
      mockLocalAuth.exceptionToThrow = const LocalAuthException(
        code: LocalAuthExceptionCode.userCanceled,
      );
      await cubit.load();
      await Future(() {});

      await cubit.toggleLock(true);
      await Future(() {});

      const key = 'is_local_auth_enabled';
      final saved = await mockStorage.read(key: key);
      expect(saved, 'false');
      expect(cubit.state, isA<SettingsToggleError>());
    });
  });

  group('toggleLock - disable', () {
    test('persists disabled flag on successful auth', () async {
      await mockStorage.write(key: 'is_local_auth_enabled', value: 'true');
      await cubit.load();
      await Future(() {});

      await cubit.toggleLock(false);
      await Future(() {});

      const key = 'is_local_auth_enabled';
      final saved = await mockStorage.read(key: key);
      expect(saved, 'false');
      expect(cubit.state, isA<SettingsLoadSuccess>());
      expect((cubit.state as SettingsLoadSuccess).isLockEnabled, false);
    });
  });
}

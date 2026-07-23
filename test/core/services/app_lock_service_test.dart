import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/services/app_lock_service.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockLocalAuthentication mockLocalAuth;
  late MockSecureStorageService mockStorage;
  // late BiometricAuthService biometricAuthService;
  late AppLockService service;

  setUp(() {
    mockLocalAuth = MockLocalAuthentication();
    mockStorage = MockSecureStorageService();
    // biometricAuthService = BiometricAuthService(mockLocalAuth);
    service = AppLockService(
      mockStorage,
      //  biometricAuthService
    );
  });

  group('AppLockService default logic', () {
    test(
      'first read with device supported persists and returns true',
      () async {
        mockLocalAuth.isDeviceSupportedResult = true;

        final result = await service.isEnabled();

        expect(result, true);
        final stored = await mockStorage.read(key: 'is_local_auth_enabled');
        expect(stored, 'true');
      },
    );

    test(
      'first read with device unsupported persists and returns false',
      () async {
        mockLocalAuth.isDeviceSupportedResult = false;

        final result = await service.isEnabled();

        expect(result, false);
        final stored = await mockStorage.read(key: 'is_local_auth_enabled');
        expect(stored, 'false');
      },
    );

    test(
      'subsequent read returns stored value without re-triggering default',
      () async {
        mockLocalAuth.isDeviceSupportedResult = true;
        await service.isEnabled();

        mockLocalAuth.isDeviceSupportedResult = false;
        final result = await service.isEnabled();

        expect(result, true);
      },
    );

    test('subsequent read after explicit setDisabled returns false', () async {
      mockLocalAuth.isDeviceSupportedResult = true;
      await service.isEnabled();

      await service.setDisabled();
      final result = await service.isEnabled();

      expect(result, false);
    });

    test('subsequent read after explicit setEnabled returns true', () async {
      mockLocalAuth.isDeviceSupportedResult = false;
      await service.isEnabled();

      await service.setEnabled();
      final result = await service.isEnabled();

      expect(result, true);
    });
  });
}

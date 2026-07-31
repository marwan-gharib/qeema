import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/services/app_lock_service.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockSecureStorageService mockStorage;
  late AppLockService service;

  setUp(() {
    mockStorage = MockSecureStorageService();
    service = AppLockService(mockStorage);
  });

  group('AppLockService', () {
    test('isEnabled returns false when nothing is stored', () async {
      final result = await service.isEnabled();

      expect(result, false);
    });

    test('isEnabled returns true when the stored value is true', () async {
      await mockStorage.write(key: 'is_local_auth_enabled', value: 'true');

      final result = await service.isEnabled();

      expect(result, true);
    });

    test('isEnabled returns false when the stored value is false', () async {
      await mockStorage.write(key: 'is_local_auth_enabled', value: 'false');

      final result = await service.isEnabled();

      expect(result, false);
    });

    test('setEnabled persists true and isEnabled reflects it', () async {
      await service.setEnabled();

      expect(await service.isEnabled(), true);
      final stored = await mockStorage.read(key: 'is_local_auth_enabled');
      expect(stored, 'true');
    });

    test('setDisabled persists false and isEnabled reflects it', () async {
      await service.setDisabled();

      expect(await service.isEnabled(), false);
      final stored = await mockStorage.read(key: 'is_local_auth_enabled');
      expect(stored, 'false');
    });
  });
}

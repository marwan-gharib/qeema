import 'package:qeema/core/local/secure/secure_storage_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/utils/logger.dart';

class AppLockService {
  AppLockService(this._storage, [this._biometricAuthService]);
  final SecureStorageService _storage;
  final BiometricAuthService? _biometricAuthService;

  static const _lockEnabledKey = 'is_local_auth_enabled';

  Future<bool> isEnabled() async {
    final value = await _storage.read(key: _lockEnabledKey);
    if (value == null) {
      return _setDefault();
    }
    Logger.info('[AppLock] isEnabled: raw="$value" → ${value == 'true'}');
    return value == 'true';
  }

  Future<bool> _setDefault() async {
    final supported = _biometricAuthService != null
        ? await _biometricAuthService.isDeviceSupported
        : false;
    Logger.info(
      '[AppLock] first-run default — deviceSupported: $supported',
    );
    final defaultEnabled = supported;
    await _storage.write(
      key: _lockEnabledKey,
      value: defaultEnabled ? 'true' : 'false',
    );
    return defaultEnabled;
  }

  Future<void> setEnabled() async {
    Logger.info('[AppLock] setEnabled');
    await _storage.write(key: _lockEnabledKey, value: 'true');
  }

  Future<void> setDisabled() async {
    Logger.info('[AppLock] setDisabled');
    await _storage.write(key: _lockEnabledKey, value: 'false');
  }
}

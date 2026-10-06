import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/local/cache/cache_service.dart';

class AppLockLocalDataSource {
  AppLockLocalDataSource(this._cache);
  final CacheService _cache;

  Future<bool> isEnabled() async {
    final value = await _cache.get(key: AppConstants.appLockEnabledKey);
    if (value is bool) return value;
    return true;
  }

  Future<void> setEnabled(bool enabled) =>
      _cache.set(key: AppConstants.appLockEnabledKey, value: enabled);
}

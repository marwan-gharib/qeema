import 'package:shared_preferences/shared_preferences.dart';

import 'cache_service.dart';

final class CacheServiceImpl implements CacheService {
  final SharedPreferences _prefs;

  CacheServiceImpl(this._prefs);

  @override
  Future<void> set({required String key, required String value}) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> get({required String key}) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> remove({required String key}) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}

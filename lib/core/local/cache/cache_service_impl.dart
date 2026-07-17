import 'package:qeema/core/local/cache/cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class CacheServiceImpl implements CacheService {
  CacheServiceImpl(this._prefs);
  final SharedPreferences _prefs;

  @override
  Future<void> set({required String key, required dynamic value}) async {
    switch (value) {
      case String _:
        await _prefs.setString(key, value);
        break;
      case int _:
        await _prefs.setInt(key, value);
        break;
      case double _:
        await _prefs.setDouble(key, value);
        break;
      case bool _:
        await _prefs.setBool(key, value);
        break;
      case List<String> _:
        await _prefs.setStringList(key, value);
        break;
      default:
        throw UnsupportedError('Unsupported value type: ${value.runtimeType}');
    }
  }

  @override
  Future<dynamic> get({required String key}) async {
    return _prefs.get(key);
  }

  @override
  dynamic getSync({required String key}) => _prefs.get(key);

  @override
  Future<void> remove({required String key}) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}

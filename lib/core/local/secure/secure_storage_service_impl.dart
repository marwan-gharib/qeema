import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qeema/core/local/secure/secure_storage_service.dart';
import 'package:qeema/core/utils/logger.dart';

class SecureStorageServiceImpl implements SecureStorageService {
  SecureStorageServiceImpl(this._storage);
  final FlutterSecureStorage _storage;

  @override
  Future<void> write({required String key, required String value}) async {
    Logger.info('[SecureStorage] write(key: $key, value: $value)');
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) async {
    final value = await _storage.read(key: key);
    Logger.info('[SecureStorage] read(key: $key) → "${value ?? "null"}"');
    return value;
  }

  @override
  Future<void> delete({required String key}) async {
    Logger.info('[SecureStorage] delete(key: $key)');
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    Logger.info('[SecureStorage] deleteAll');
    await _storage.deleteAll();
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qeema/core/local/secure/secure_storage_service.dart';

class SecureStorageServiceImpl implements SecureStorageService {
  SecureStorageServiceImpl(this._storage);
  final FlutterSecureStorage _storage;

  @override
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}

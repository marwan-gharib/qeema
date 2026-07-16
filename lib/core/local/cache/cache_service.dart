abstract class CacheService {
  Future<void> set({required String key, required String value});
  Future<String?> get({required String key});
  Future<void> remove({required String key});
  Future<void> clear();
}

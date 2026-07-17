abstract class CacheService {
  Future<void> set({required String key, required dynamic value});
  Future<dynamic> get({required String key});
  dynamic getSync({required String key});
  Future<void> remove({required String key});
  Future<void> clear();
}

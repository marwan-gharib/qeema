import '../error/failures.dart';
import '../utils/api_result.dart';

class SyncService {
  Future<ApiResult<void>> syncNow() async {
    try {
      return const Success(null);
    } catch (_) {
      return ResultFailure(const ServerFailure('Sync failed'));
    }
  }
}

import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';

class SyncService {
  Future<ApiResult<void>> syncNow() async {
    try {
      return const Success(null);
    } catch (_) {
      return const ResultFailure(ServerFailure(null));
    }
  }
}

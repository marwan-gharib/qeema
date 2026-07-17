import 'package:qeema/core/utils/api_result.dart';

abstract class UseCaseWithoutParams<Output> {
  Future<ApiResult<Output>> call();
}

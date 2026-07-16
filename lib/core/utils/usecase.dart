import 'api_result.dart';

abstract class UseCase<Output, Input> {
  Future<ApiResult<Output>> call(Input input);
}

abstract class UseCaseWithoutParams<Output> {
  Future<ApiResult<Output>> call();
}

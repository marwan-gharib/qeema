import 'package:qeema/core/utils/api_result.dart';
export 'usecase_without_params.dart';

abstract class UseCase<Output, Input> {
  Future<ApiResult<Output>> call(Input input);
}

abstract class StreamUseCase<Output, Input> {
  Stream<ApiResult<Output>> call(Input input);
}

abstract class StreamUseCaseWithoutParams<Output> {
  Stream<ApiResult<Output>> call();
}

import 'package:qeema/core/utils/api_result.dart';

abstract class UseCase<Output, Input> {
  Future<ApiResult<Output>> call(Input input);
}

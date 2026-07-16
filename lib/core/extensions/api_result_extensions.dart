import '../error/failures.dart';
import '../utils/api_result.dart';

extension ApiResultExtensions<T> on ApiResult<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;
  Failure? get failureOrNull =>
      fold<Failure?>(onSuccess: (_) => null, onFailure: (f) => f);
  T? get dataOrNull =>
      fold<T?>(onSuccess: (data) => data, onFailure: (_) => null);
}

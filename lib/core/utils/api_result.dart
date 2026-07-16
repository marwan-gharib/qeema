import '../error/failures.dart';

sealed class ApiResult<T> {
  const ApiResult();

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  });
}

final class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);

  @override
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => onSuccess(data);
}

final class ResultFailure<T> extends ApiResult<T> {
  final Failure failure;
  const ResultFailure(this.failure);

  @override
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => onFailure(failure);
}

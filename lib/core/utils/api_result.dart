import 'package:qeema/core/error/failures.dart';

sealed class ApiResult<T> {
  const ApiResult();

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  });
}

final class Success<T> extends ApiResult<T> {
  const Success(this.data);
  final T data;

  @override
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => onSuccess(data);
}

final class ResultFailure<T> extends ApiResult<T> {
  const ResultFailure(this.failure);
  final Failure failure;

  @override
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => onFailure(failure);
}

import 'package:dio/dio.dart';
import 'package:qeema/core/error/exceptions.dart';

class ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = switch (err.type) {
      DioExceptionType.connectionTimeout => const ServerException(null),
      DioExceptionType.receiveTimeout => const ServerException(null),
      DioExceptionType.connectionError => const ServerException(null),
      DioExceptionType.badResponse => ServerException(
        err.response?.statusMessage,
      ),
      _ => ServerException(err.message),
    };
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: mapped,
        type: err.type,
      ),
    );
  }
}

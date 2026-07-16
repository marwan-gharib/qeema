import 'package:dio/dio.dart';

import '../../error/exceptions.dart';

class ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = switch (err.type) {
      DioExceptionType.connectionTimeout => ServerException(
        'Connection timed out',
      ),
      DioExceptionType.receiveTimeout => ServerException(
        'Server did not respond',
      ),
      DioExceptionType.connectionError => const ServerException(
        'Could not connect to server',
      ),
      DioExceptionType.badResponse => ServerException(
        '${err.response?.statusCode ?? "Unknown"}: ${err.response?.statusMessage ?? "Request failed"}',
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

import 'package:dio/dio.dart';
import 'package:qeema/core/error/failure_mapper.dart';
import 'package:qeema/core/network/base_api_client.dart';
import 'package:qeema/core/network/interceptors/auth_interceptor.dart';
import 'package:qeema/core/network/interceptors/error_mapping_interceptor.dart';
import 'package:qeema/core/network/interceptors/logging_interceptor.dart';
import 'package:qeema/core/utils/api_result.dart';

class DioApiClient implements BaseApiClient {
  DioApiClient({required String baseUrl, AuthInterceptor? authInterceptor}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    final interceptors = <Interceptor>[
      LoggingInterceptor(),
      ErrorMappingInterceptor(),
    ];
    if (authInterceptor != null) {
      interceptors.insert(0, authInterceptor);
    }
    _dio.interceptors.addAll(interceptors);
  }
  late final Dio _dio;

  @override
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
      );
      return Success(response.data as T);
    } catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<ApiResult<T>> post<T>(String path, {dynamic data}) async {
    try {
      final response = await _dio.post<T>(path, data: data);
      return Success(response.data as T);
    } catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<ApiResult<T>> put<T>(String path, {dynamic data}) async {
    try {
      final response = await _dio.put<T>(path, data: data);
      return Success(response.data as T);
    } catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<ApiResult<T>> delete<T>(String path) async {
    try {
      final response = await _dio.delete<T>(path);
      return Success(response.data as T);
    } catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }
}

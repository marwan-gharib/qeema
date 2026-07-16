import '../utils/api_result.dart';

abstract class BaseApiClient {
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  });
  Future<ApiResult<T>> post<T>(String path, {dynamic data});
  Future<ApiResult<T>> put<T>(String path, {dynamic data});
  Future<ApiResult<T>> delete<T>(String path);
}

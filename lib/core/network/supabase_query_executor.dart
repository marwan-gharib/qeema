import 'package:qeema/core/error/failure_mapper.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseQueryExecutor {
  const SupabaseQueryExecutor(this._provider);
  final SupabaseClientProvider _provider;

  Future<ApiResult<T>> run<T>(
    Future<T> Function(SupabaseClient client) query,
  ) async {
    try {
      final result = await query(_provider.client);
      return Success(result);
    } catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }
}

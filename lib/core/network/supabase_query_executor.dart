import 'package:supabase_flutter/supabase_flutter.dart';

import '../error/failure_mapper.dart';
import '../utils/api_result.dart';
import 'supabase_client_provider.dart';

class SupabaseQueryExecutor {
  final SupabaseClientProvider _provider;
  const SupabaseQueryExecutor(this._provider);

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

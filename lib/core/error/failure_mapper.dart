import 'package:qeema/core/error/exceptions.dart' as app;
import 'package:qeema/core/error/failures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Failure mapExceptionToFailure(Object error) {
  return switch (error) {
    final app.ServerException e => ServerFailure(e.message),
    final app.CacheException e => ServerFailure(e.message),
    final app.AuthException e => AuthFailure(e.message),
    final PostgrestException e => ServerFailure(e.message),
    final AuthApiException e => AuthFailure(e.message),
    _ => const UnknownFailure(),
  };
}

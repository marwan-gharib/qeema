import 'package:supabase_flutter/supabase_flutter.dart';

import 'exceptions.dart' as app;
import 'failures.dart';

Failure mapExceptionToFailure(Object error) {
  return switch (error) {
    app.ServerException e => ServerFailure(e.message ?? 'Server error'),
    app.CacheException e => CacheFailure(e.message ?? 'Cache error'),
    app.AuthException e => AuthFailure(e.message ?? 'Authentication error'),
    PostgrestException e => ServerFailure(e.message),
    AuthApiException e => AuthFailure(e.message),
    _ => const UnknownFailure(),
  };
}

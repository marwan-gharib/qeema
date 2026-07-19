import 'dart:io';
import 'package:qeema/core/error/exceptions.dart' as app;
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Failure mapExceptionToFailure(Object error) {
  return switch (error) {
    final app.ServerException e => ServerFailure(e.message),
    final app.CacheException e => ServerFailure(e.message),
    final app.AuthException e => AuthFailure(e.message),
    final PostgrestException e => ServerFailure(e.message),
    final AuthApiException e => _mapAuthApiException(e),
    final AuthException e => AuthFailure(e.message),
    final SocketException _ => const NetworkAuthFailure(),
    final HttpException _ => const NetworkAuthFailure(),
    _ => const UnknownFailure(),
  };
}

Failure _mapAuthApiException(AuthApiException e) {
  return switch (e.code) {
    'over_request_rate_limit' => const TooManyRequestsFailure(),
    'over_email_send_rate_limit' => const TooManyRequestsFailure(),
    'over_sms_send_rate_limit' => const TooManyRequestsFailure(),
    'anonymous_provider_disabled' => const AnonymousSignInDisabledFailure(),
    _ => _logUnknown(e),
  };
}

Failure _logUnknown(AuthApiException e) {
  Logger.error(
    'Unmapped AuthApiException: code=${e.code} message=${e.message}',
  );
  return UnknownAuthFailure(e.message);
}

import 'dart:io';
import 'package:qeema/core/error/exceptions.dart' as app;
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Translates an exception into a typed [Failure]. No branch ever produces
/// displayable text — messages are stored as `debugDetail` for logs only.
Failure mapExceptionToFailure(Object error) {
  return switch (error) {
    final app.ServerException e => _mapServerException(e),
    final app.CacheException e => CacheFailure(e.message, 'cache'),
    final app.AuthException e => AuthFailure(e.message, 'auth'),
    final app.AccountDeletionPartialException e =>
      AccountDeletionPartialFailure(e.message),
    final app.AccountDeletionException e => AccountDeletionFailure(e.message),
    final PostgrestException e => _mapPostgrestException(e),
    final AuthApiException e => _mapAuthApiException(e),
    final AuthException e => AuthFailure(e.message, e.code),
    final FunctionsHttpException e => AccountDeletionFailure(
      e.details?.toString(),
    ),
    final FunctionsRelayException e => AccountDeletionFailure(
      e.details?.toString(),
    ),
    final FunctionsFetchException e => AccountDeletionFailure(
      e.details?.toString(),
    ),
    final SocketException _ => const NetworkAuthFailure(null, 'socket'),
    final HttpException _ => const NetworkAuthFailure(null, 'http'),
    final app.SignOutException _ => const SignOutFailure(null, 'sign_out'),
    _ => const UnknownFailure(),
  };
}

Failure _mapServerException(app.ServerException e) {
  final code = e.code;
  if (code == 'timeout') return TimeoutFailure(e.message, code);
  if (code == 'connection_error') return NetworkFailure(e.message, code);
  return switch (code) {
    '401' => SessionExpiredFailure(e.message, code),
    '403' => ForbiddenFailure(e.message, code),
    '404' => NotFoundFailure(e.message, code),
    '408' => TimeoutFailure(e.message, code),
    '429' => TooManyRequestsFailure(e.message, code),
    _ => ServerFailure(e.message, code),
  };
}

Failure _mapPostgrestException(PostgrestException e) {
  if (e.code == 'PGRST301' || e.message.contains('JWT')) {
    return SessionExpiredFailure(e.message, e.code);
  }
  return ServerFailure(e.message, e.code);
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
  return UnknownAuthFailure(e.message, e.code);
}

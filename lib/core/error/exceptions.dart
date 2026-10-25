/// [code] is a machine-readable identifier (HTTP status, Dio error type, or a
/// domain code) — never displayable text.
class ServerException implements Exception {
  const ServerException([this.message, this.code]);
  final String? message;
  final String? code;
}

class AuthException implements Exception {
  const AuthException([this.message]);
  final String? message;
}

class CacheException implements Exception {
  const CacheException([this.message]);
  final String? message;
}

class SignOutException implements Exception {
  const SignOutException([this.message]);
  final String? message;
}

class AccountDeletionException implements Exception {
  const AccountDeletionException([this.message]);
  final String? message;
}

class AccountDeletionPartialException implements Exception {
  const AccountDeletionPartialException([this.message]);
  final String? message;
}

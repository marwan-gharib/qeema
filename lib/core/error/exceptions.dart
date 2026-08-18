class ServerException implements Exception {
  const ServerException([this.message]);
  final String? message;
}

class AuthException implements Exception {
  const AuthException([this.message]);
  final String? message;
}

class CacheException implements Exception {
  const CacheException([this.message]);
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

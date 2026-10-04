import 'package:qeema/core/utils/api_result.dart';

abstract class AccountRepository {
  Future<ApiResult<void>> deleteAccount();

  /// Logs out based on the live account type:
  /// - anonymous → deletes the account server-side, then signs out locally;
  /// - otherwise → sign-out only, server data untouched.
  Future<ApiResult<void>> logout();

  /// Reads `isAnonymous` from the live Supabase user.
  /// Returns false when the user is null (safe branch: sign out only).
  bool isCurrentUserAnonymous();
}

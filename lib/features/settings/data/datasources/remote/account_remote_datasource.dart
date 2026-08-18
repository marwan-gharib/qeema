import 'package:qeema/core/error/exceptions.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountRemoteDataSource {
  AccountRemoteDataSource(this._provider);
  final SupabaseClientProvider _provider;

  static const _deleteAccountFunction = 'delete-account';

  /// Invokes the `delete-account` Edge Function with the current session's
  /// access token attached automatically by the client's auth header.
  ///
  /// The function always answers HTTP 200 with a body flag so the result can
  /// be inspected deterministically:
  /// - `{success: true}` — server-side deletion completed.
  /// - `{success: false, partial: true}` — data rows were deleted but the
  ///   auth user record could not be removed; the user must retry.
  /// - `{success: false}` — nothing was deleted.
  Future<void> deleteAccount() async {
    try {
      final response = await _provider.client.functions.invoke(
        _deleteAccountFunction,
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) return;
      if (data is Map<String, dynamic> && data['partial'] == true) {
        throw const AccountDeletionPartialException();
      }
      throw const AccountDeletionException();
    } on FunctionsHttpException catch (error) {
      // A partial deletion is reported as HTTP 500 by the function, so the
      // body only reaches us through the exception's details.
      final details = error.details;
      if (details is Map<String, dynamic> && details['partial'] == true) {
        throw const AccountDeletionPartialException();
      }
      throw const AccountDeletionException();
    }
  }

  /// Drops the local session after the server-side user is gone.
  Future<void> signOut() async {
    await _provider.client.auth.signOut();
  }
}

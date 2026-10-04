import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:qeema/core/error/exceptions.dart' as app;
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountRemoteDataSource {
  AccountRemoteDataSource(this._provider, [this.googleSignIn]);
  final SupabaseClientProvider _provider;
  final GoogleSignIn? googleSignIn;

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
  ///
  /// [userConfirmed] marks the Danger Zone flow, where the user explicitly
  /// typed the DELETE confirmation — only then does the server allow a
  /// permanent (non-anonymous) account to be deleted. The automatic
  /// guest-logout path never sets it, so the server still refuses to delete
  /// a permanent account even if the client misclassifies the user.
  Future<void> deleteAccount({bool userConfirmed = false}) async {
    try {
      final response = await _provider.client.functions.invoke(
        _deleteAccountFunction,
        body: <String, Object>{'userConfirmed': userConfirmed},
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) return;
      if (data is Map<String, dynamic> && data['partial'] == true) {
        throw const app.AccountDeletionPartialException();
      }
      throw const app.AccountDeletionException();
    } on FunctionsHttpException catch (error) {
      // A partial deletion is reported as HTTP 500 by the function, so the
      // body only reaches us through the exception's details.
      Logger.warning('Account deletion failed: ${error.details}');
      final details = error.details;
      if (details is Map<String, dynamic> && details['partial'] == true) {
        throw const app.AccountDeletionPartialException();
      }
      throw const app.AccountDeletionException();
    }
  }

  /// Drops the local session after the server-side user is gone.
  /// Signs out from both Supabase and Google if applicable.
  ///
  /// [scope] defaults to local: after a guest account has been deleted
  /// server-side a global sign-out may fail because the user no longer
  /// exists. Errors are swallowed because a failed sign-out must never
  /// block local cleanup — the local session is removed before the
  /// network call anyway.
  Future<void> signOut({SignOutScope scope = SignOutScope.local}) async {
    try {
      await _provider.client.auth.signOut(scope: scope);
    } catch (e) {
      Logger.warning('Sign out failed: $e');
      throw const app.SignOutException();
    }
    // Sign out from Google as well if the user logged in with Google,
    // so the next login shows the account picker and no stale session remains.
    if (googleSignIn != null) {
      try {
        await googleSignIn!.signOut();
        await googleSignIn!.disconnect();
      } catch (e) {
        Logger.warning('Google sign out failed: $e');
        throw const app.SignOutException();
      }
    }
  }

  /// Reads the live Supabase user to determine the account type.
  /// Returns false when the user is null (safe branch: sign out only).
  bool isCurrentUserAnonymous() =>
      _provider.client.auth.currentUser?.isAnonymous ?? false;
}

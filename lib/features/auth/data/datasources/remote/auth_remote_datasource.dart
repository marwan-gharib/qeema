import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/features/auth/data/mappers/auth_user_mapper.dart';
import 'package:qeema/features/auth/data/models/auth_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._provider);
  final SupabaseClientProvider _provider;

  Future<AuthUserModel> signInAnonymously() async {
    final response = await _provider.client.auth.signInAnonymously();
    final user = response.user;
    if (user == null) {
      throw const AuthException(
        'No user returned from anonymous sign-in',
        code: 'unexpected_failure',
      );
    }
    return AuthUserMapper.fromSupabaseUser(user);
  }

  Future<AuthUserModel> _nativeGoogleSignIn() async {
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '378564854492-b5pnn90s01ure2m5stnpni5db72us193.apps.googleusercontent.com';

    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId =
        '378564854492-nel3phko7i6flqeskc95ro6ovkoj3b9p.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android

    try {
      final GoogleSignIn signIn = GoogleSignIn.instance;

      // At the start of your app, initialize the GoogleSignIn instance
      await signIn.initialize(
        clientId: Platform.isIOS ? iosClientId : null,
        serverClientId: webClientId,
      );

      // Perform the sign in
      final googleAccount = await signIn.authenticate();
      final googleAuthentication = googleAccount.authentication;
      final idToken = googleAuthentication.idToken;

      if (idToken == null) {
        throw const AuthException(
          'No ID Token found.',
          code: 'unexpected_failure',
        );
      }

      final response = await _provider.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
      final user = response.user;

      if (user == null) {
        throw const AuthException(
          'No user returned from Google sign-in',
          code: 'unexpected_failure',
        );
      }

      return AuthUserMapper.fromSupabaseUser(user);
    } on GoogleSignInException catch (e) {
      throw AuthException(
        'Google sign-in failed: ${e.code}',
        code: 'google_sign_in_error',
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw const AuthException(
        'Failed to sign in with Google.',
        code: 'unexpected_failure',
      );
    }
  }

  Future<AuthUserModel> googleSignIn() async {
    try {
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        return await _nativeGoogleSignIn();
      } else {
        await _provider.client.auth.signInWithOAuth(OAuthProvider.google);

        return const AuthUserModel(email: '', id: '', isAnonymous: false);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Emits the mapped current user, seeded once and then on every auth
  /// event. `currentUser` is read per event because gotrue updates it before
  /// notifying listeners, so replays can never surface stale data.
  Stream<AuthUserModel?> authStateChanges() async* {
    final auth = _provider.client.auth;
    yield _currentUserInfo();
    // Transient auth errors are swallowed so a failed token refresh never
    // tears down the stream; no auth data is logged.
    await for (final _ in auth.onAuthStateChange.handleError((Object _) {})) {
      yield _currentUserInfo();
    }
  }

  AuthUserModel? _currentUserInfo() {
    final user = _provider.client.auth.currentUser;
    if (user == null) return null;
    return AuthUserMapper.fromSupabaseUser(user);
  }
}

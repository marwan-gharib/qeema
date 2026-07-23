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
}

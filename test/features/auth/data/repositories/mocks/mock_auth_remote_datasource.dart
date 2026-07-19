import 'package:qeema/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:qeema/features/auth/data/models/auth_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  bool shouldThrowAnonymousDisabled = false;

  @override
  Future<AuthUserModel> signInAnonymously() async {
    if (shouldThrowAnonymousDisabled) {
      throw const AuthApiException(
        'Anonymous sign-ins are disabled',
        code: 'anonymous_provider_disabled',
      );
    }
    return const AuthUserModel(id: 'anon-1', email: '', isAnonymous: true);
  }
}

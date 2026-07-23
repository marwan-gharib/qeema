import 'package:qeema/features/auth/data/models/auth_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUserMapper {
  const AuthUserMapper._();

  static AuthUserModel fromSupabaseUser(User user) => AuthUserModel(
    id: user.id,
    email: user.email ?? '',
    isAnonymous: user.isAnonymous,
  );
}

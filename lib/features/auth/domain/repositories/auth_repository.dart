import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<ApiResult<AuthUserEntity>> continueAsGuest();
  Future<ApiResult<AuthUserEntity>> googleSignIn();

  /// Live stream of the current user. Emits `Success(null)` when signed out
  /// and `ResultFailure` when the auth state cannot be read.
  Stream<ApiResult<AuthUserEntity?>> authStateChanges();
}

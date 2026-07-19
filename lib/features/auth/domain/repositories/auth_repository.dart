import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<ApiResult<AuthUserEntity>> continueAsGuest();
}

import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/auth/domain/repositories/auth_repository.dart';

class ContinueAsGuestUseCase {
  const ContinueAsGuestUseCase(this._repository);
  final AuthRepository _repository;

  Future<ApiResult<AuthUserEntity>> call() => _repository.continueAsGuest();
}

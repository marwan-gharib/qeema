import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase_without_params.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/auth/domain/repositories/auth_repository.dart';

class ContinueAsGuestUseCase implements UseCaseWithoutParams<AuthUserEntity> {
  const ContinueAsGuestUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<ApiResult<AuthUserEntity>> call() => _repository.continueAsGuest();
}

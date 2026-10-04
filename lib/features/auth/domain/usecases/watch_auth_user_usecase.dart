import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/auth/domain/repositories/auth_repository.dart';

class WatchAuthUserUseCase extends StreamUseCaseWithoutParams<AuthUserEntity?> {
  WatchAuthUserUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Stream<ApiResult<AuthUserEntity?>> call() => _repository.authStateChanges();
}

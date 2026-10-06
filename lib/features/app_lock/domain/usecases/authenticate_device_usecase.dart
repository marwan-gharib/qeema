import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/usecase.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/domain/repositories/app_lock_repository.dart';

class AuthenticateDeviceUseCase implements UseCase<AppLockStatus, String> {
  const AuthenticateDeviceUseCase(this._repository);
  final AppLockRepository _repository;

  @override
  Future<ApiResult<AppLockStatus>> call(String input) =>
      _repository.authenticate(input);
}

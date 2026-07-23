import 'package:qeema/core/error/failure_mapper.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/auth/domain/repositories/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);
  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<AuthUserEntity>> continueAsGuest() async {
    try {
      final model = await _remoteDataSource.signInAnonymously();
      return Success(model.toEntity());
    } catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }
}

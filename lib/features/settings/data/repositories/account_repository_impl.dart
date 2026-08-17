import 'package:qeema/core/error/failure_mapper.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/local/cache/cache_service.dart';
import 'package:qeema/core/local/secure/secure_storage_service.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/settings/data/datasources/remote/account_remote_datasource.dart';
import 'package:qeema/features/settings/domain/repositories/account_repository.dart';

final class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(
    this._remoteDataSource,
    this._database,
    this._secureStorage,
    this._cacheService,
  );

  final AccountRemoteDataSource _remoteDataSource;
  final AppDatabase _database;
  final SecureStorageService _secureStorage;
  final CacheService _cacheService;

  @override
  Future<ApiResult<void>> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      await _database.clearAll();
      await _secureStorage.deleteAll();
      await _cacheService.clear();
      // The server-side user is already gone; drop the stale local session
      // reference so the SDK cannot hold on to a deleted identity.
      await _remoteDataSource.signOut();
      return const Success(null);
    } catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }
}

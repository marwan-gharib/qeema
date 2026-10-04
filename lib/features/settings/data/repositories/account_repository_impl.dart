import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/error/failure_mapper.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/local/cache/cache_service.dart';
import 'package:qeema/core/local/secure/secure_storage_service.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/utils/logger.dart';
import 'package:qeema/features/settings/data/datasources/remote/account_remote_datasource.dart';
import 'package:qeema/features/settings/domain/repositories/account_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  bool isCurrentUserAnonymous() => _remoteDataSource.isCurrentUserAnonymous();

  @override
  Future<ApiResult<void>> logout() async {
    if (!_remoteDataSource.isCurrentUserAnonymous()) {
      return _signOutOnly();
    }

    // Guest: delete the account and ALL related data permanently.
    // If deletion fails, do NOT sign out and do NOT clear local data —
    // that would leave an orphaned account the user cannot access.
    // No user confirmation is sent, so the server still enforces that only
    // an anonymous account may be deleted through this automatic path.
    try {
      await _remoteDataSource.deleteAccount();
      // User no longer exists server-side; local sign-out may 401/403.
      // signOut() swallows its own errors, so this cannot throw.
      await _remoteDataSource.signOut(scope: SignOutScope.local);
      await _clearLocalData();
      return const Success(null);
    } catch (e) {
      Logger.warning('Account logout failed: ${e.toString()}');
      return ResultFailure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<ApiResult<void>> deleteAccount() async {
    try {
      // Danger Zone: the user typed the DELETE confirmation, which lets the
      // server accept deletion of a permanent (Google/email) account too.
      await _remoteDataSource.deleteAccount(userConfirmed: true);
      await _clearLocalData();
      await _remoteDataSource.signOut(scope: SignOutScope.local);
      return const Success(null);
    } catch (e) {
      Logger.warning('Account deletion failed: ${e.toString()}');
      return ResultFailure(mapExceptionToFailure(e));
    }
  }

  Future<ApiResult<void>> _signOutOnly() async {
    try {
      await _remoteDataSource.signOut(scope: SignOutScope.local);
      await _clearLocalData();
      return const Success(null);
    } catch (e) {
      Logger.warning('Account sign-out failed: ${e.toString()}');
      return ResultFailure(mapExceptionToFailure(e));
    }
  }

  Future<ApiResult<void>> _clearLocalData() async {
    try {
      await _database.clearAll();
      await _secureStorage.deleteAll();
      await _cacheService.clear();
      await _cacheService.set(
        key: AppConstants.onboardingCompletedKey,
        value: true,
      );
      return const Success(null);
    } catch (e) {
      Logger.warning('Failed to clear local data: ${e.toString()}');
      return ResultFailure(mapExceptionToFailure(e));
    }
  }
}

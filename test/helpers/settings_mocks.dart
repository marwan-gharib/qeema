import 'package:google_sign_in/google_sign_in.dart';
import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/settings/data/datasources/remote/account_remote_datasource.dart';
import 'package:qeema/features/settings/domain/repositories/account_repository.dart';
import 'package:qeema/features/settings/domain/usecases/delete_account_usecase.dart';
import 'package:qeema/features/settings/domain/usecases/logout_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAccountRemoteDataSource implements AccountRemoteDataSource {
  int deleteAccountCalls = 0;
  int signOutCalls = 0;
  Exception? errorToThrow;
  bool anonymousResult = false;
  bool? lastUserConfirmed;

  @override
  GoogleSignIn? googleSignIn;

  @override
  bool isCurrentUserAnonymous() => anonymousResult;

  @override
  Future<void> deleteAccount({bool userConfirmed = false}) async {
    deleteAccountCalls++;
    lastUserConfirmed = userConfirmed;
    final error = errorToThrow;
    if (error != null) throw error;
  }

  @override
  Future<void> signOut({SignOutScope scope = SignOutScope.local}) async {
    signOutCalls++;
    final error = errorToThrow;
    if (error != null) throw error;
  }
}

/// A fake [AppDatabase] whose drift connection is never opened — only
/// [clearAll] is exercised, so no sqlite file or platform channel is needed.
class MockAppDatabase extends AppDatabase {
  int clearAllCalls = 0;

  @override
  Future<void> clearAll() async {
    clearAllCalls++;
  }
}

class MockDeleteAccountUseCase implements DeleteAccountUseCase {
  ApiResult<void> result = const Success(null);
  int calls = 0;

  @override
  Future<ApiResult<void>> call() async {
    calls++;
    return result;
  }
}

class MockLogoutUseCase implements LogoutUseCase {
  ApiResult<void> result = const Success(null);
  int calls = 0;

  @override
  Future<ApiResult<void>> call() async {
    calls++;
    return result;
  }
}

class MockAccountRepository implements AccountRepository {
  MockAccountRepository({this.isAnonymous = false});
  final bool isAnonymous;

  ApiResult<void> logoutResult = const Success(null);
  ApiResult<void> deleteAccountResult = const Success(null);

  @override
  bool isCurrentUserAnonymous() => isAnonymous;

  @override
  Future<ApiResult<void>> logout() async => logoutResult;

  @override
  Future<ApiResult<void>> deleteAccount() async => deleteAccountResult;
}

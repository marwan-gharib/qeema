import 'package:qeema/core/local/cache/app_database.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/settings/data/datasources/remote/account_remote_datasource.dart';
import 'package:qeema/features/settings/domain/usecases/delete_account_usecase.dart';

class MockAccountRemoteDataSource implements AccountRemoteDataSource {
  int deleteAccountCalls = 0;
  int signOutCalls = 0;
  Exception? errorToThrow;

  @override
  Future<void> deleteAccount() async {
    deleteAccountCalls++;
    final error = errorToThrow;
    if (error != null) throw error;
  }

  @override
  Future<void> signOut() async {
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

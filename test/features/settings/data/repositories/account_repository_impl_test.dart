import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/exceptions.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/settings/data/repositories/account_repository_impl.dart';

import '../../../../helpers/mocks.dart';
import '../../../../helpers/settings_mocks.dart';

void main() {
  late MockAccountRemoteDataSource dataSource;
  late MockAppDatabase database;
  late MockSecureStorageService secureStorage;
  late MockCacheService cacheService;
  late AccountRepositoryImpl repository;

  setUp(() {
    dataSource = MockAccountRemoteDataSource();
    database = MockAppDatabase();
    secureStorage = MockSecureStorageService();
    cacheService = MockCacheService();
    repository = AccountRepositoryImpl(
      dataSource,
      database,
      secureStorage,
      cacheService,
    );
  });

  test('success clears all local caches and signs out', () async {
    await cacheService.set(key: 'k', value: 'v');
    await secureStorage.write(key: 'lock', value: 'true');

    final result = await repository.deleteAccount();

    expect(result, isA<Success<void>>());
    expect(dataSource.deleteAccountCalls, 1);
    expect(database.clearAllCalls, 1);
    expect(dataSource.signOutCalls, 1);
    expect(cacheService.getSync(key: 'k'), isNull);
    expect(await secureStorage.read(key: 'lock'), isNull);
  });

  test('does not touch local state when the server call fails', () async {
    await cacheService.set(key: 'k', value: 'v');
    await secureStorage.write(key: 'lock', value: 'true');
    dataSource.errorToThrow = const AccountDeletionException();

    final result = await repository.deleteAccount();

    expect(result, isA<ResultFailure<void>>());
    expect(
      (result as ResultFailure<void>).failure,
      isA<AccountDeletionFailure>(),
    );
    expect(database.clearAllCalls, 0);
    expect(dataSource.signOutCalls, 0);
    expect(cacheService.getSync(key: 'k'), 'v');
    expect(await secureStorage.read(key: 'lock'), 'true');
  });

  test('maps a partial deletion to the partial failure', () async {
    dataSource.errorToThrow = const AccountDeletionPartialException();

    final result = await repository.deleteAccount();

    expect(
      (result as ResultFailure<void>).failure,
      isA<AccountDeletionPartialFailure>(),
    );
  });

  test('maps a generic datasource error to an unknown failure', () async {
    dataSource.errorToThrow = Exception('boom');

    final result = await repository.deleteAccount();

    expect((result as ResultFailure<void>).failure, isA<UnknownFailure>());
  });
}

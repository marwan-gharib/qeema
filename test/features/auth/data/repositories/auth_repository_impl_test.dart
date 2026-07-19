import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'mocks/mock_auth_remote_datasource.dart';

void main() {
  late MockAuthRemoteDataSource mockDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });

  group('AuthRepositoryImpl', () {
    test('continueAsGuest returns Success with anonymous user', () async {
      final result = await repository.continueAsGuest();
      expect(result, isA<Success<AuthUserEntity>>());
      (result as Success).fold(
        onSuccess: (entity) {
          expect(entity.isAnonymous, isTrue);
          expect(entity.email, '');
        },
        onFailure: (_) => fail('Expected success'),
      );
    });

    test('continueAsGuest maps anonymous_provider_disabled to '
        'AnonymousSignInDisabledFailure', () async {
      mockDataSource.shouldThrowAnonymousDisabled = true;

      final result = await repository.continueAsGuest();
      expect(result, isA<ResultFailure<AuthUserEntity>>());
      (result as ResultFailure).fold(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (failure) =>
            expect(failure, isA<AnonymousSignInDisabledFailure>()),
      );
    });
  });
}

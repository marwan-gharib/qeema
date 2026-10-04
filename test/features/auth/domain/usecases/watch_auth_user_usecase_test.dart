import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/auth/domain/usecases/watch_auth_user_usecase.dart';

import '../../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository repository;
  late WatchAuthUserUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = WatchAuthUserUseCase(repository);
  });

  test('forwards the repository auth stream', () async {
    repository.authStateChangesStream = Stream.value(
      const Success(AuthUserEntity(id: 'user-1', email: '')),
    );

    final events = await useCase().toList();

    expect(events, hasLength(1));
    expect(events.single, isA<Success<AuthUserEntity?>>());
  });

  test('propagates repository failures as stream results', () async {
    repository.authStateChangesStream = Stream.value(
      const ResultFailure<AuthUserEntity?>(CacheFailure()),
    );

    final events = await useCase().toList();

    expect(events.single, isA<ResultFailure<AuthUserEntity?>>());
  });
}

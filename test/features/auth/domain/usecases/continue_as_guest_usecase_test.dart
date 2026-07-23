import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/auth/domain/usecases/continue_as_guest_usecase.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockAuthRepository mockRepo;
  late ContinueAsGuestUseCase useCase;

  setUp(() {
    mockRepo = MockAuthRepository();
    useCase = ContinueAsGuestUseCase(mockRepo);
  });

  group('ContinueAsGuestUseCase', () {
    test('returns Success with anonymous user', () async {
      final result = await useCase();
      expect(result, isA<Success<AuthUserEntity>>());
      (result as Success).fold(
        onSuccess: (entity) {
          expect(entity.isAnonymous, isTrue);
        },
        onFailure: (_) => fail('Expected success'),
      );
    });

    test('propagates failure from repository', () async {
      mockRepo.continueAsGuestResult = const ResultFailure(
        AnonymousSignInDisabledFailure(),
      );
      final result = await useCase();
      expect(result, isA<ResultFailure<AuthUserEntity>>());
      (result as ResultFailure).fold(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (failure) =>
            expect(failure, isA<AnonymousSignInDisabledFailure>()),
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/onboarding/domain/usecases/get_onboarding_seen_usecase.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockOnboardingRepository mockRepo;
  late GetOnboardingSeenUseCase useCase;

  setUp(() {
    mockRepo = MockOnboardingRepository();
    useCase = GetOnboardingSeenUseCase(mockRepo);
  });

  group('GetOnboardingSeenUseCase', () {
    test('returns Success(true) when repository returns true', () async {
      mockRepo.hasSeenResult = true;

      final result = await useCase();
      expect(result, isA<Success<bool>>());
      (result as Success<bool>).fold(
        onSuccess: (value) => expect(value, isTrue),
        onFailure: (_) => fail('Expected success'),
      );
    });

    test('returns Success(false) when repository returns false', () async {
      mockRepo.hasSeenResult = false;

      final result = await useCase();
      expect(result, isA<Success<bool>>());
      (result as Success<bool>).fold(
        onSuccess: (value) => expect(value, isFalse),
        onFailure: (_) => fail('Expected success'),
      );
    });

    test('propagates ResultFailure from repository', () async {
      mockRepo.shouldFailOnRead = true;

      final result = await useCase();
      expect(result, isA<ResultFailure<bool>>());
    });
  });
}

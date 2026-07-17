import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockOnboardingRepository mockRepo;
  late CompleteOnboardingUseCase useCase;

  setUp(() {
    mockRepo = MockOnboardingRepository();
    useCase = CompleteOnboardingUseCase(mockRepo);
  });

  group('CompleteOnboardingUseCase', () {
    test('returns Success(null) on normal completion', () async {
      final result = await useCase();
      expect(result, isA<Success<void>>());
      expect(mockRepo.hasSeenResult, isTrue);
    });

    test('propagates ResultFailure from repository', () async {
      mockRepo.shouldFailOnWrite = true;

      final result = await useCase();
      expect(result, isA<ResultFailure<void>>());
    });
  });
}

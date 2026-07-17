import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late MockCacheService mockCache;
  late OnboardingRepositoryImpl repository;

  setUp(() {
    mockCache = MockCacheService();
    repository = OnboardingRepositoryImpl(mockCache);
  });

  group('OnboardingRepositoryImpl', () {
    test(
      'round-trip: markOnboardingSeen then hasSeenOnboarding returns Success(true)',
      () async {
        final writeResult = await repository.markOnboardingSeen();
        expect(writeResult, isA<Success<void>>());

        final readResult = await repository.hasSeenOnboarding();
        expect(readResult, isA<Success<bool>>());
        (readResult as Success<bool>).fold(
          onSuccess: (value) => expect(value, isTrue),
          onFailure: (_) => fail('Expected success'),
        );
      },
    );

    test(
      'hasSeenOnboarding with no prior write returns Success(false)',
      () async {
        final result = await repository.hasSeenOnboarding();
        expect(result, isA<Success<bool>>());
        (result as Success<bool>).fold(
          onSuccess: (value) => expect(value, isFalse),
          onFailure: (_) => fail('Expected success'),
        );
      },
    );

    test(
      'hasSeenOnboarding maps CacheService exception to ResultFailure',
      () async {
        mockCache.shouldThrowOnRead = true;

        final result = await repository.hasSeenOnboarding();
        expect(result, isA<ResultFailure<bool>>());
        (result as ResultFailure<bool>).fold(
          onSuccess: (_) => fail('Expected failure'),
          onFailure: (failure) => expect(failure, isA<CacheFailure>()),
        );
      },
    );

    test(
      'markOnboardingSeen maps CacheService exception to ResultFailure',
      () async {
        mockCache.shouldThrowOnWrite = true;

        final result = await repository.markOnboardingSeen();
        expect(result, isA<ResultFailure<void>>());
        (result as ResultFailure<void>).fold(
          onSuccess: (_) => fail('Expected failure'),
          onFailure: (failure) => expect(failure, isA<CacheFailure>()),
        );
      },
    );
  });
}

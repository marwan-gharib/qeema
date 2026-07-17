import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/local/cache/cache_service.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:qeema/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:qeema/features/onboarding/domain/usecases/get_onboarding_seen_usecase.dart';

class MockCacheService implements CacheService {
  final Map<String, dynamic> _store = {};
  bool shouldThrowOnRead = false;
  bool shouldThrowOnWrite = false;

  @override
  Future<void> set({required String key, required dynamic value}) async {
    if (shouldThrowOnWrite) throw Exception('mock write error');
    _store[key] = value;
  }

  @override
  Future<dynamic> get({required String key}) async {
    if (shouldThrowOnRead) throw Exception('mock read error');
    return _store[key];
  }

  @override
  dynamic getSync({required String key}) => _store[key];

  @override
  Future<void> remove({required String key}) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }
}

class MockOnboardingRepository implements OnboardingRepository {
  bool hasSeenResult = false;
  bool shouldFailOnRead = false;
  bool shouldFailOnWrite = false;

  @override
  Future<ApiResult<bool>> hasSeenOnboarding() async {
    if (shouldFailOnRead) {
      return const ResultFailure(CacheFailure());
    }
    return Success(hasSeenResult);
  }

  @override
  Future<ApiResult<void>> markOnboardingSeen() async {
    if (shouldFailOnWrite) {
      return const ResultFailure(CacheFailure());
    }
    hasSeenResult = true;
    return const Success(null);
  }
}

class MockCompleteOnboardingUseCase implements CompleteOnboardingUseCase {
  ApiResult<void> result = const Success(null);

  @override
  Future<ApiResult<void>> call() async => result;
}

class MockGetOnboardingSeenUseCase implements GetOnboardingSeenUseCase {
  ApiResult<bool> result = const Success(false);

  @override
  Future<ApiResult<bool>> call() async => result;
}

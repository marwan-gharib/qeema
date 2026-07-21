import 'package:local_auth/local_auth.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart'
    show AuthMessages;
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/local/cache/cache_service.dart';
import 'package:qeema/core/local/secure/secure_storage_service.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/auth/domain/repositories/auth_repository.dart';
import 'package:qeema/features/auth/domain/usecases/continue_as_guest_usecase.dart';
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

class MockAuthRepository implements AuthRepository {
  ApiResult<AuthUserEntity> continueAsGuestResult = const Success(
    AuthUserEntity(id: 'anon-1', email: '', isAnonymous: true),
  );

  @override
  Future<ApiResult<AuthUserEntity>> continueAsGuest() async =>
      continueAsGuestResult;
}

class MockContinueAsGuestUseCase implements ContinueAsGuestUseCase {
  ApiResult<AuthUserEntity> result = const Success(
    AuthUserEntity(id: 'anon-1', email: '', isAnonymous: true),
  );

  @override
  Future<ApiResult<AuthUserEntity>> call() async => result;
}

class MockLocalAuthentication implements LocalAuthentication {
  bool authenticateResult = true;
  bool throwException = false;
  LocalAuthException? exceptionToThrow;
  bool isDeviceSupportedResult = true;
  bool canCheckBiometricsResult = false;
  List<BiometricType> availableBiometrics = [];

  @override
  Future<bool> authenticate({
    required String localizedReason,
    Iterable<AuthMessages> authMessages = const <AuthMessages>[],
    bool biometricOnly = false,
    bool sensitiveTransaction = true,
    bool persistAcrossBackgrounding = false,
  }) async {
    if (throwException) {
      throw exceptionToThrow ??
          const LocalAuthException(code: LocalAuthExceptionCode.unknownError);
    }
    return authenticateResult;
  }

  @override
  Future<bool> get canCheckBiometrics async => canCheckBiometricsResult;

  @override
  Future<bool> isDeviceSupported() async => isDeviceSupportedResult;

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async =>
      availableBiometrics;

  @override
  Future<bool> stopAuthentication() async => false;
}

class MockSecureStorageService implements SecureStorageService {
  final Map<String, String> _store = {};

  @override
  Future<void> write({required String key, required String value}) async {
    _store[key] = value;
  }

  @override
  Future<String?> read({required String key}) async => _store[key];

  @override
  Future<void> delete({required String key}) async {
    _store.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _store.clear();
  }
}

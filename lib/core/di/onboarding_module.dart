import 'package:get_it/get_it.dart';
import 'package:qeema/core/local/cache/cache_service.dart';
import 'package:qeema/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:qeema/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:qeema/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:qeema/features/onboarding/domain/usecases/get_onboarding_seen_usecase.dart';
import 'package:qeema/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';

Future<void> initOnboardingModule(GetIt getIt) async {
  getIt.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(getIt<CacheService>()),
  );
  getIt.registerLazySingleton(
    () => GetOnboardingSeenUseCase(getIt<OnboardingRepository>()),
  );
  getIt.registerLazySingleton(
    () => CompleteOnboardingUseCase(getIt<OnboardingRepository>()),
  );
  getIt.registerFactory(
    () => OnboardingCubit(getIt<CompleteOnboardingUseCase>()),
  );
}

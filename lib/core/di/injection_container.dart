import 'package:get_it/get_it.dart';
import 'package:qeema/core/di/app_lock_module.dart';
import 'package:qeema/core/di/auth_module.dart';
import 'package:qeema/core/di/core_module.dart';
import 'package:qeema/core/di/onboarding_module.dart';
import 'package:qeema/core/di/settings_module.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/router/route_guards.dart';
import 'package:qeema/features/onboarding/domain/usecases/get_onboarding_seen_usecase.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await initCoreModule(getIt);
  await initOnboardingModule(getIt);
  await initAuthModule(getIt);
  initAppLockModule(getIt);
  initSettingsModule(getIt);

  /*
  this is a temporary solution to avoid circular dependency between core_module and onboarding_module
  register RouteGuards after onboarding module is initialized, because RouteGuards depends on GetOnboardingSeenUseCase which is registered in onboarding_module
  */
  getIt.registerLazySingleton<RouteGuards>(
    () => RouteGuards(
      getIt<SupabaseClientProvider>(),
      getIt<GetOnboardingSeenUseCase>(),
    ),
  );
}

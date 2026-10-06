import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/router/app_lock_gate.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/features/onboarding/domain/usecases/get_onboarding_seen_usecase.dart';

class RouteGuards {
  RouteGuards(
    this._provider,
    this._getOnboardingSeenUseCase,
    this._appLockGate,
  ) {
    _provider.client.auth.onAuthStateChange.listen((_) {
      authListenable.value++;
    });
  }

  final SupabaseClientProvider _provider;
  final ValueNotifier<int> authListenable = ValueNotifier(0);
  final GetOnboardingSeenUseCase _getOnboardingSeenUseCase;
  final AppLockGate _appLockGate;

  /// Fires on every lock-state change so the router re-runs its redirect if needed.
  Listenable get appLockListenable => _appLockGate.listenable;

  Future<String?> redirectUnauthenticated(
    BuildContext context,
    GoRouterState state,
  ) async {
    final location = state.matchedLocation;

    // App lock is handled via root overlay instead of route redirects.
    // If navigating directly to /lock, redirect to home.
    if (location == RoutePaths.lock) {
      return RoutePaths.home;
    }

    final onSplash = location == RoutePaths.splash;
    if (onSplash) {
      return null;
    }

    final onboardingResult = await _getOnboardingSeenUseCase();
    final hasSeenOnboarding = onboardingResult.fold(
      onSuccess: (seen) => seen,
      onFailure: (_) => true,
    );

    final onOnboarding = state.matchedLocation == RoutePaths.onboarding;

    if (!hasSeenOnboarding) {
      return onOnboarding ? null : RoutePaths.onboarding;
    }

    final session = _provider.client.auth.currentSession;
    final isLoggedIn = session != null;

    if (onOnboarding) {
      return isLoggedIn ? RoutePaths.home : RoutePaths.welcome;
    }

    final onWelcome = state.matchedLocation == RoutePaths.welcome;

    if (!isLoggedIn && !onWelcome) {
      return RoutePaths.welcome;
    }

    if (isLoggedIn && onWelcome) {
      return RoutePaths.home;
    }

    return null;
  }
}

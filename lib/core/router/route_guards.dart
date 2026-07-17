import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/features/onboarding/domain/usecases/get_onboarding_seen_usecase.dart';

class RouteGuards {
  RouteGuards(this._provider, this._getOnboardingSeenUseCase) {
    _provider.client.auth.onAuthStateChange.listen((_) {
      authListenable.value++;
    });
  }
  final SupabaseClientProvider _provider;
  final ValueNotifier<int> authListenable = ValueNotifier(0);
  final GetOnboardingSeenUseCase _getOnboardingSeenUseCase;

  Future<String?> redirectUnauthenticated(
    BuildContext context,
    GoRouterState state,
  ) async {
    final onOnboarding = state.matchedLocation == RoutePaths.onboarding;
    final onSplash = state.matchedLocation == RoutePaths.splash;
    if (onOnboarding || onSplash) return null;

    final result = await _getOnboardingSeenUseCase();
    result.fold(
      onSuccess: (hasSeenOnboarding) {
        if (!hasSeenOnboarding) {
          return RoutePaths.onboarding;
        }
      },
      onFailure: (_) {},
    );

    final session = _provider.client.auth.currentSession;
    final isLoggedIn = session != null;
    final onAuthScreen =
        state.matchedLocation.startsWith(RoutePaths.login) ||
        state.matchedLocation.startsWith(RoutePaths.signUp) ||
        state.matchedLocation.startsWith(RoutePaths.forgotPassword) ||
        state.matchedLocation.startsWith(RoutePaths.welcome);

    if (!isLoggedIn && !onAuthScreen) {
      return RoutePaths.login;
    }

    if (isLoggedIn && onAuthScreen) {
      return RoutePaths.home;
    }

    return null;
  }
}

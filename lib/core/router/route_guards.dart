import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../network/supabase_client_provider.dart';
import 'route_names.dart';

class RouteGuards {
  final SupabaseClientProvider _provider;
  final ValueNotifier<int> authListenable = ValueNotifier(0);

  RouteGuards(this._provider) {
    _provider.client.auth.onAuthStateChange.listen((_) {
      authListenable.value++;
    });
  }

  String? redirectUnauthenticated(BuildContext context, GoRouterState state) {
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

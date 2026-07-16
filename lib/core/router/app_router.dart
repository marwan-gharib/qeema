import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_guards.dart';
import 'route_names.dart';

class AppRouter {
  final RouteGuards _routeGuards;
  AppRouter(this._routeGuards);

  GoRouter create() {
    return GoRouter(
      initialLocation: RoutePaths.splash,
      refreshListenable: _routeGuards.authListenable,
      redirect: _routeGuards.redirectUnauthenticated,
      routes: [
        GoRoute(
          path: RoutePaths.splash,
          name: RouteNames.splash,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Splash'))),
        ),
        GoRoute(
          path: RoutePaths.welcome,
          name: RouteNames.welcome,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Welcome'))),
        ),
        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Login'))),
        ),
        GoRoute(
          path: RoutePaths.signUp,
          name: RouteNames.signUp,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Sign Up'))),
        ),
        GoRoute(
          path: RoutePaths.forgotPassword,
          name: RouteNames.forgotPassword,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Forgot Password'))),
        ),
        GoRoute(
          path: RoutePaths.biometricSetup,
          name: RouteNames.biometricSetup,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Biometric Setup'))),
        ),
        GoRoute(
          path: RoutePaths.home,
          name: RouteNames.home,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Home'))),
        ),
        GoRoute(
          path: RoutePaths.assets,
          name: RouteNames.assets,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Assets'))),
          routes: [
            GoRoute(
              path: RouteSegments.add,
              name: RouteNames.addAsset,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Add Asset'))),
            ),
            GoRoute(
              path: RouteSegments.assetId,
              name: RouteNames.assetDetail,
              builder: (context, state) {
                final assetId = state.pathParameters['assetId']!;
                return Scaffold(body: Center(child: Text('Asset $assetId')));
              },
              routes: [
                GoRoute(
                  path: RouteSegments.edit,
                  name: RouteNames.editAsset,
                  builder: (context, state) {
                    final assetId = state.pathParameters['assetId']!;
                    return Scaffold(
                      body: Center(child: Text('Edit Asset $assetId')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.insights,
          name: RouteNames.insights,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Insights'))),
        ),
        GoRoute(
          path: RoutePaths.goals,
          name: RouteNames.goals,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Goals'))),
          routes: [
            GoRoute(
              path: RouteSegments.add,
              name: RouteNames.addGoal,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Add Goal'))),
            ),
            GoRoute(
              path: RouteSegments.goalId,
              name: RouteNames.goalDetail,
              builder: (context, state) {
                final goalId = state.pathParameters['goalId']!;
                return Scaffold(body: Center(child: Text('Goal $goalId')));
              },
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.marketPrices,
          name: RouteNames.marketPrices,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Market Prices'))),
        ),
        GoRoute(
          path: RoutePaths.notifications,
          name: RouteNames.notifications,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Notifications'))),
          routes: [
            GoRoute(
              path: RouteSegments.settings,
              name: RouteNames.notificationSettings,
              builder: (context, state) => const Scaffold(
                body: Center(child: Text('Notification Settings')),
              ),
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.profile,
          name: RouteNames.profile,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Profile'))),
        ),
        GoRoute(
          path: RoutePaths.settings,
          name: RouteNames.settings,
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Settings'))),
        ),
      ],
    );
  }
}

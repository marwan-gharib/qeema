import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/animations/app_page_transitions.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_guards.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/core/router/route_segments.dart';
import 'package:qeema/features/assets/presentation/cubits/add_asset_cubit/add_asset_cubit.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_cubit.dart';
import 'package:qeema/features/assets/presentation/screens/add_asset_screen.dart';
import 'package:qeema/features/assets/presentation/screens/assets_list_screen.dart';
import 'package:qeema/features/auth/presentation/cubits/welcome_cubit/welcome_cubit.dart';
import 'package:qeema/features/auth/presentation/screens/welcome_screen.dart';
import 'package:qeema/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:qeema/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:qeema/features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  AppRouter._();
  static final RouteGuards _routeGuards = getIt<RouteGuards>();

  static GoRouter router = GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: _routeGuards.authListenable,
    redirect: _routeGuards.redirectUnauthenticated,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        pageBuilder: (context, state) => fadeThroughPage(
          child: BlocProvider(
            create: (context) => getIt<OnboardingCubit>(),
            child: const OnboardingScreen(),
          ),
          pageKey: const ValueKey('onboarding'),
        ),
      ),
      GoRoute(
        path: RoutePaths.welcome,
        name: RouteNames.welcome,
        pageBuilder: (context, state) => slideUpPage(
          child: BlocProvider(
            create: (context) => getIt<WelcomeCubit>(),
            child: const WelcomeScreen(),
          ),
          pageKey: const ValueKey('welcome'),
        ),
      ),
      GoRoute(
        path: RoutePaths.biometricSetup,
        name: RouteNames.biometricSetup,
        builder: (context, state) => Scaffold(
          body: Center(child: Text(context.t.navigation.biometricSetup)),
        ),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) =>
            Scaffold(body: Center(child: Text(context.t.navigation.home))),
      ),
      GoRoute(
        path: RoutePaths.assets,
        name: RouteNames.assets,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AssetsListCubit>()..loadAssets(),
          child: const AssetsListScreen(),
        ),
        routes: [
          GoRoute(
            path: RouteSegments.add,
            name: RouteNames.addAsset,
            pageBuilder: (context, state) => slideUpPage(
              child: BlocProvider(
                create: (_) => getIt<AddAssetCubit>()..loadAssetTypes(),
                child: const AddAssetScreen(),
              ),
              pageKey: const ValueKey('addAsset'),
            ),
          ),
          GoRoute(
            path: RouteSegments.assetId,
            name: RouteNames.assetDetail,
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'Asset Detail — Coming Soon'),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.insights,
        name: RouteNames.insights,
        builder: (context, state) =>
            Scaffold(body: Center(child: Text(context.t.navigation.insights))),
      ),
      GoRoute(
        path: RoutePaths.goals,
        name: RouteNames.goals,
        builder: (context, state) =>
            Scaffold(body: Center(child: Text(context.t.navigation.goals))),
        routes: [
          GoRoute(
            path: RouteSegments.add,
            name: RouteNames.addGoal,
            builder: (context, state) => Scaffold(
              body: Center(child: Text(context.t.navigation.addGoal)),
            ),
          ),
          GoRoute(
            path: RouteSegments.goalId,
            name: RouteNames.goalDetail,
            builder: (context, state) {
              final goalId = state.pathParameters['goalId']!;
              return Scaffold(
                body: Center(
                  child: Text(
                    context.t.navigation.goalDetail.replaceAll('{id}', goalId),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.marketPrices,
        name: RouteNames.marketPrices,
        builder: (context, state) => Scaffold(
          body: Center(child: Text(context.t.navigation.marketPrices)),
        ),
      ),
      GoRoute(
        path: RoutePaths.notifications,
        name: RouteNames.notifications,
        builder: (context, state) => Scaffold(
          body: Center(child: Text(context.t.navigation.notifications)),
        ),
        routes: [
          GoRoute(
            path: RouteSegments.settings,
            name: RouteNames.notificationSettings,
            builder: (context, state) => Scaffold(
              body: Center(
                child: Text(context.t.navigation.notificationSettings),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.profile,
        name: RouteNames.profile,
        builder: (context, state) =>
            Scaffold(body: Center(child: Text(context.t.navigation.profile))),
      ),
    ],
  );
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}

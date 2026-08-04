import 'package:go_router/go_router.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/router/app_router_routes.dart';
import 'package:qeema/core/router/route_guards.dart';
import 'package:qeema/core/router/route_paths.dart';

class AppRouter {
  AppRouter._();

  static final RouteGuards _routeGuards = getIt<RouteGuards>();
  static StatefulShellRoute? _shellRoute;

  static StatefulShellRoute get shellRoute =>
      _shellRoute ??= AppRouterRoutes.buildShellRoute();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: _routeGuards.authListenable,
    redirect: _routeGuards.redirectUnauthenticated,
    routes: AppRouterRoutes.buildRoutes(routeGuards: _routeGuards),
  );
}

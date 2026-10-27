import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/splash/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('renders the brand text on splash', (tester) async {
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: RoutePaths.splash,
                name: RouteNames.splash,
                builder: (_, _) => const SplashScreen(),
              ),
              GoRoute(
                path: RoutePaths.onboarding,
                name: RouteNames.onboarding,
                builder: (_, _) => const Scaffold(body: Text('Onboarding')),
              ),
            ],
            initialLocation: RoutePaths.splash,
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Qeema'), findsOneWidget);

    // Advance past the splash sequence so no timer is pending at disposal.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
  });

  testWidgets('navigates to onboarding after the splash sequence', (
    tester,
  ) async {
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: RoutePaths.splash,
                name: RouteNames.splash,
                builder: (_, _) => const SplashScreen(),
              ),
              GoRoute(
                path: RoutePaths.onboarding,
                name: RouteNames.onboarding,
                builder: (_, _) => const Scaffold(body: Text('Onboarding')),
              ),
            ],
            initialLocation: RoutePaths.splash,
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Advance time past the splash sequence (5000 ms) to trigger navigation.
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();

    expect(find.text('Onboarding'), findsOneWidget);
  });
}

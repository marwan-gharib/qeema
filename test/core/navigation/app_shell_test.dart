import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/navigation/app_shell.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/core/router/route_segments.dart';
import 'package:qeema/core/theme/app_theme.dart';

class _HomeStub extends StatelessWidget {
  const _HomeStub();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Home Stub'),
          TextField(key: Key('homeField')),
        ],
      ),
    );
  }
}

class _AssetsStub extends StatelessWidget {
  const _AssetsStub();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Assets Stub'));
  }
}

class _AddStub extends StatelessWidget {
  const _AddStub();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Add Stub'));
  }
}

GoRouter _buildRouter() {
  return GoRouter(
    initialLocation: RoutePaths.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                name: RouteNames.home,
                builder: (_, _) => const _HomeStub(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.assets,
                name: RouteNames.assets,
                builder: (_, _) => const _AssetsStub(),
                routes: [
                  GoRoute(
                    path: RouteSegments.add,
                    name: RouteNames.addAsset,
                    builder: (_, _) => const _AddStub(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

Future<GoRouter> _pumpApp(WidgetTester tester) async {
  final router = _buildRouter();
  await tester.pumpWidget(
    TranslationProvider(
      child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    ),
  );
  await _settle(tester);
  return router;
}

/// Fixed-duration pumps instead of [pumpAndSettle] — a focused text field's
/// blinking cursor never settles.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  testWidgets('switching tabs preserves the other branch state', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.enterText(find.byKey(const Key('homeField')), 'draft text');

    await tester.tap(find.text('Assets'));
    await _settle(tester);
    expect(find.text('Assets Stub'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await _settle(tester);
    expect(find.text('draft text'), findsOneWidget);
  });

  testWidgets('tapping the active tab resets the branch to its initial route', (
    tester,
  ) async {
    final router = await _pumpApp(tester);

    await tester.tap(find.text('Assets'));
    await _settle(tester);

    unawaited(router.pushNamed(RouteNames.addAsset));
    await _settle(tester);
    expect(find.text('Add Stub'), findsOneWidget);

    await tester.tap(find.text('Assets'));
    await _settle(tester);

    expect(find.text('Add Stub'), findsNothing);
    expect(find.text('Assets Stub'), findsOneWidget);
  });

  testWidgets('switching back to a branch keeps its pushed route', (
    tester,
  ) async {
    final router = await _pumpApp(tester);

    await tester.tap(find.text('Assets'));
    await _settle(tester);

    unawaited(router.pushNamed(RouteNames.addAsset));
    await _settle(tester);

    await tester.tap(find.text('Home'));
    await _settle(tester);

    await tester.tap(find.text('Assets'));
    await _settle(tester);

    expect(find.text('Add Stub'), findsOneWidget);
  });
}

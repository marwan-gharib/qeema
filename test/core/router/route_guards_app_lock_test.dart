import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/router/app_lock_gate.dart';
import 'package:qeema/core/router/route_guards.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/onboarding/domain/usecases/get_onboarding_seen_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helpers/app_lock_mocks.dart';

class _FakeSupabaseClientProvider extends SupabaseClientProvider {
  _FakeSupabaseClientProvider(this._client);

  final SupabaseClient _client;

  @override
  SupabaseClient get client => _client;
}

final _signedInClient = SupabaseClient(
  'https://qeema-test.supabase.co',
  'anon-test-key',
);
final _anonymousClient = SupabaseClient(
  'https://qeema-anonymous.supabase.co',
  'anon-test-key',
);

String _fakeJwt() {
  final header = base64UrlEncode(utf8.encode('{"alg":"HS256","typ":"JWT"}'));
  final exp =
      DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch ~/
      1000;
  final payload = base64UrlEncode(
    utf8.encode('{"sub":"test-user","role":"authenticated","exp":$exp}'),
  );
  return '$header.$payload.fake-signature';
}

String _fakeSessionJson() {
  return jsonEncode({
    'access_token': _fakeJwt(),
    'refresh_token': 'fake-refresh-token',
    'expires_in': 3600,
    'token_type': 'bearer',
    'user': {
      'id': 'test-user',
      'aud': 'authenticated',
      'role': 'authenticated',
      'email': 'test@qeema.test',
      'app_metadata': {'provider': 'email'},
      'user_metadata': const <String, dynamic>{},
      'identities': const <Map<String, dynamic>>[],
      'created_at': '2024-01-01T00:00:00Z',
      'updated_at': '2024-01-01T00:00:00Z',
    },
  });
}

class _StubOnboardingSeenUseCase implements GetOnboardingSeenUseCase {
  ApiResult<bool> result = const Success(true);

  @override
  Future<ApiResult<bool>> call() async => result;
}

({GoRouter router, List<String?> redirects}) _buildRouter(
  SupabaseClientProvider provider,
  GetOnboardingSeenUseCase onboardingSeen,
  AppLockGate gate,
) {
  final guards = RouteGuards(provider, onboardingSeen, gate);
  // The guard's return value is the thing under test: the rendered route is
  // masked by the auth guard, which bounces a restored location elsewhere.
  final redirects = <String?>[];
  final router = GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: Listenable.merge([guards.appLockListenable]),
    redirect: (context, state) async {
      final result = await guards.redirectUnauthenticated(context, state);
      redirects.add(result);
      return result;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (_, _) => const Scaffold(body: Text('splash')),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (_, _) => const Scaffold(body: Text('onboarding')),
      ),
      GoRoute(
        path: RoutePaths.welcome,
        builder: (_, _) => const Scaffold(body: Text('welcome')),
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (_, _) => const Scaffold(body: Text('home')),
      ),
      GoRoute(
        path: RoutePaths.lock,
        builder: (_, _) => const Scaffold(body: Text('lock')),
      ),
    ],
  );
  return (router: router, redirects: redirects);
}

void main() {
  late FakeAppLockGate gate;
  late _StubOnboardingSeenUseCase onboardingSeen;
  late GoRouter router;
  late SupabaseClient anonymousClient;

  setUp(() async {
    // Fail closed by default: every case below starts with the gate closed,
    // which is the state the app is in on a cold start.
    gate = FakeAppLockGate(locked: true);
    onboardingSeen = _StubOnboardingSeenUseCase();
    // A signed-in user keeps the auth guard out of the way, so an assertion
    // about a restored location cannot be confused with an auth redirect.
    await _signedInClient.auth.recoverSession(_fakeSessionJson());
    // Read here so the client is built in the real async zone: Supabase starts
    // an auto-refresh timer per client, and one built under fake async would
    // still be pending when a widget tree is disposed.
    anonymousClient = _anonymousClient;
    final built = _buildRouter(
      _FakeSupabaseClientProvider(_signedInClient),
      onboardingSeen,
      gate,
    );
    router = built.router;
  });

  tearDown(() {
    router.dispose();
  });

  Future<void> settle(WidgetTester tester) =>
      tester.pumpAndSettle(const Duration(milliseconds: 20));

  testWidgets('a cold start on splash is not redirected while the gate is '
      'closed', (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await settle(tester);

    expect(find.text('splash'), findsOneWidget);
  });

  testWidgets(
    'a protected route does not redirect to the lock route (overlay owns locking)',
    (tester) async {
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await settle(tester);

      router.go(RoutePaths.home);
      await settle(tester);

      // Route guards do not redirect to /lock; screens remain intact.
      expect(find.text('home'), findsOneWidget);
    },
  );

  testWidgets('navigating directly to the lock route redirects to home', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await settle(tester);

    router.go(RoutePaths.lock);
    await settle(tester);

    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('the auth guard still runs for unauthenticated user', (
    tester,
  ) async {
    final anonymous = _buildRouter(
      _FakeSupabaseClientProvider(anonymousClient),
      onboardingSeen,
      gate,
    ).router;
    addTearDown(anonymous.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: anonymous));
    await settle(tester);

    anonymous.go(RoutePaths.home);
    await settle(tester);

    expect(find.text('welcome'), findsOneWidget);
  });

  testWidgets('the onboarding guard still runs when onboarding is not seen', (
    tester,
  ) async {
    onboardingSeen.result = const Success(false);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await settle(tester);

    router.go(RoutePaths.home);
    await settle(tester);

    expect(find.text('onboarding'), findsOneWidget);
  });
}

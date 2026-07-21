import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/network/supabase_client_provider.dart';
import 'package:qeema/core/services/app_lock_service.dart';
import 'package:qeema/core/services/biometric_auth_service.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_gate.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../helpers/mocks.dart';

class MockSupabaseClientProvider extends SupabaseClientProvider {
  MockSupabaseClientProvider()
    : _client = SupabaseClient('http://localhost', 'key');
  final SupabaseClient _client;

  @override
  SupabaseClient get client => _client;
}

class _MockLockCubit extends LockCubit {
  _MockLockCubit(super.service);

  @override
  Future<void> authenticate({required String localizedReason}) async {}
}

Widget _buildTestApp({
  required AppLockService lockService,
  required BiometricAuthService bioService,
  required SupabaseClientProvider supabaseProvider,
  Stream<AuthState>? authStateStream,
}) {
  LocaleSettings.setLocaleSync(AppLocale.en);
  return TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: AppLockGate(
        appLockService: lockService,
        biometricAuthService: bioService,
        supabaseClientProvider: supabaseProvider,
        authStateStream: authStateStream,
        lockCubit: _MockLockCubit(bioService),
        child: const Text('app content'),
      ),
    ),
  );
}

void main() {
  late MockLocalAuthentication mockLocalAuth;
  late MockSecureStorageService mockStorage;
  late BiometricAuthService biometricAuthService;
  late AppLockService appLockService;
  late SupabaseClientProvider mockSupabaseProvider;

  setUp(() {
    mockLocalAuth = MockLocalAuthentication();
    mockStorage = MockSecureStorageService();
    biometricAuthService = BiometricAuthService(mockLocalAuth);
    appLockService = AppLockService(mockStorage);
    mockSupabaseProvider = MockSupabaseClientProvider();
  });

  group('AppLockGate', () {
    testWidgets('no lock when flag is disabled and no session restored', (
      tester,
    ) async {
      final controller = StreamController<AuthState>.broadcast();
      addTearDown(controller.close);

      await tester.pumpWidget(
        _buildTestApp(
          lockService: appLockService,
          bioService: biometricAuthService,
          supabaseProvider: mockSupabaseProvider,
          authStateStream: controller.stream,
        ),
      );
      await tester.pump();

      controller.add(const AuthState(AuthChangeEvent.initialSession, null));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('app content'), findsOneWidget);
      expect(find.byType(LockScreen), findsNothing);
    });

    testWidgets('no lock on cold start when no session restored', (
      tester,
    ) async {
      await appLockService.setEnabled();
      final controller = StreamController<AuthState>.broadcast();
      addTearDown(controller.close);

      await tester.pumpWidget(
        _buildTestApp(
          lockService: appLockService,
          bioService: biometricAuthService,
          supabaseProvider: mockSupabaseProvider,
          authStateStream: controller.stream,
        ),
      );
      await tester.pump();

      controller.add(const AuthState(AuthChangeEvent.initialSession, null));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LockScreen), findsNothing);
      expect(find.text('app content'), findsOneWidget);
    });

    testWidgets('shows lock when session restored and flag enabled', (
      tester,
    ) async {
      await appLockService.setEnabled();
      final controller = StreamController<AuthState>.broadcast();
      addTearDown(controller.close);

      await tester.pumpWidget(
        _buildTestApp(
          lockService: appLockService,
          bioService: biometricAuthService,
          supabaseProvider: mockSupabaseProvider,
          authStateStream: controller.stream,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      controller.add(
        AuthState(
          AuthChangeEvent.initialSession,
          Session(
            accessToken: 'test-access',
            tokenType: 'bearer',
            user: const User(
              id: 'test-id',
              appMetadata: {},
              userMetadata: {},
              aud: 'authenticated',
              createdAt: '2025-01-01T00:00:00.000Z',
              isAnonymous: true,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LockScreen), findsOneWidget);
      expect(find.text('app content'), findsOneWidget);
    });

    testWidgets('no lock on fresh sign-in', (tester) async {
      await appLockService.setEnabled();
      final controller = StreamController<AuthState>.broadcast();
      addTearDown(controller.close);

      await tester.pumpWidget(
        _buildTestApp(
          lockService: appLockService,
          bioService: biometricAuthService,
          supabaseProvider: mockSupabaseProvider,
          authStateStream: controller.stream,
        ),
      );
      await tester.pump();

      controller.add(const AuthState(AuthChangeEvent.signedIn, null));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LockScreen), findsNothing);
      expect(find.text('app content'), findsOneWidget);
    });

    testWidgets('no lock when device not supported', (tester) async {
      mockLocalAuth.isDeviceSupportedResult = false;
      await appLockService.setEnabled();
      final controller = StreamController<AuthState>.broadcast();
      addTearDown(controller.close);

      await tester.pumpWidget(
        _buildTestApp(
          lockService: appLockService,
          bioService: biometricAuthService,
          supabaseProvider: mockSupabaseProvider,
          authStateStream: controller.stream,
        ),
      );
      await tester.pump();

      controller.add(const AuthState(AuthChangeEvent.initialSession, null));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(LockScreen), findsNothing);
      expect(find.text('app content'), findsOneWidget);
    });
  });
}

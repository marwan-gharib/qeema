import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/auth/domain/entities/auth_user_entity.dart';
import 'package:qeema/features/settings/presentation/cubits/profile_header_cubit/profile_header_cubit.dart';
import 'package:qeema/features/settings/presentation/widgets/profile_header_avatar.dart';
import 'package:qeema/features/settings/presentation/widgets/profile_header_card.dart';

import '../../../../helpers/mocks.dart';

void main() {
  const googleUser = AuthUserEntity(
    id: 'user-1',
    email: 'jane@example.com',
    displayName: 'Mariam Adel',
    avatarUrl: 'https://example.com/avatar.png',
  );
  const guestUser = AuthUserEntity(id: 'anon-1', email: '', isAnonymous: true);
  const signedOut = Success<AuthUserEntity?>(null);

  late StreamController<ApiResult<AuthUserEntity?>> controller;
  late ProfileHeaderCubit cubit;

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    controller = StreamController<ApiResult<AuthUserEntity?>>();
    cubit = ProfileHeaderCubit(
      MockWatchAuthUserUseCase()..result = controller.stream,
    );
  });

  tearDown(() async {
    if (!cubit.isClosed) await cubit.close();
    if (!controller.isClosed) await controller.close();
  });

  Widget harness({
    ThemeData? theme,
    AppLocale locale = AppLocale.en,
    TextScaler? textScaler,
  }) {
    return TranslationProvider(
      child: BlocProvider<ProfileHeaderCubit>.value(
        value: cubit,
        child: MaterialApp(
          locale: locale.flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: theme ?? AppTheme.light(),
          builder: (context, child) {
            if (textScaler == null) return child!;
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: textScaler),
              child: child!,
            );
          },
          home: const Scaffold(
            body: SingleChildScrollView(child: ProfileHeaderCard()),
          ),
        ),
      ),
    );
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
  }

  // The cubit subscribes in setUp (outside the test's async zone), so the
  // stream delivers in that zone — flush it on the real event loop before
  // pumping frames.
  Future<void> emit(
    WidgetTester tester,
    ApiResult<AuthUserEntity?> result,
  ) async {
    await tester.runAsync(() async {
      controller.add(result);
      await Future<void>.delayed(Duration.zero);
    });
    await settle(tester);
  }

  testWidgets('shows the shimmer skeleton while auth state is loading', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await settle(tester);

    expect(find.byType(ShimmerBox), findsWidgets);
    expect(find.text('Guest'), findsNothing);
    expect(find.text('Mariam Adel'), findsNothing);
  });

  testWidgets('shows avatar, name, and email for a signed-in user', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await emit(tester, const Success<AuthUserEntity?>(googleUser));

    expect(find.text('Mariam Adel'), findsOneWidget);
    expect(find.text('jane@example.com'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('shows initials when a signed-in user has no photo', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await emit(
      tester,
      const Success<AuthUserEntity?>(
        AuthUserEntity(
          id: 'user-2',
          email: 'sara@example.com',
          displayName: 'Sara Ali',
        ),
      ),
    );

    expect(find.text('SA'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.text('sara@example.com'), findsOneWidget);
  });

  testWidgets('shows the guest title and status badge for an anonymous user', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await emit(tester, const Success<AuthUserEntity?>(guestUser));

    expect(find.text('Guest'), findsOneWidget);
    expect(find.text('Signed in as guest'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('shows the neutral state when there is no user', (tester) async {
    await tester.pumpWidget(harness());
    await emit(tester, signedOut);

    expect(find.text('User'), findsOneWidget);
    expect(find.text('Signed in as guest'), findsNothing);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('falls back to the localized name when the user has none', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await emit(
      tester,
      const Success<AuthUserEntity?>(AuthUserEntity(id: 'user-3', email: '')),
    );

    expect(find.text('User'), findsOneWidget);
  });

  testWidgets('updates live when a guest becomes a signed-in user', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await emit(tester, const Success<AuthUserEntity?>(guestUser));
    expect(find.text('Guest'), findsOneWidget);

    await emit(tester, const Success<AuthUserEntity?>(googleUser));

    expect(find.text('Mariam Adel'), findsOneWidget);
    expect(find.text('Guest'), findsNothing);
    expect(find.text('Signed in as guest'), findsNothing);
  });

  testWidgets('does not overflow with a very long name and email', (
    tester,
  ) async {
    const longName = 'Μαρία-Μαρία Αλεξανδροπούλου-Κωνσταντίνου Παπαδοπούλου';
    const longEmail =
        'very.long.email.address.for.overflow.checking@subdomain.example-company.com';

    await tester.pumpWidget(harness());
    await emit(
      tester,
      const Success<AuthUserEntity?>(
        AuthUserEntity(id: 'user-4', email: longEmail, displayName: longName),
      ),
    );

    expect(find.text(longName), findsOneWidget);
    expect(find.text(longEmail), findsOneWidget);
  });

  testWidgets('renders the guest variant in Arabic RTL without overflow', (
    tester,
  ) async {
    await tester.runAsync(() => LocaleSettings.setLocale(AppLocale.ar));

    await tester.pumpWidget(harness(locale: AppLocale.ar));
    await emit(tester, const Success<AuthUserEntity?>(guestUser));

    expect(
      Directionality.of(tester.element(find.byType(ProfileHeaderCard))),
      TextDirection.rtl,
    );
    expect(find.text('ضيف'), findsOneWidget);
    expect(find.text('تم تسجيل الدخول كضيف'), findsOneWidget);
  });

  testWidgets('renders correctly in dark theme', (tester) async {
    await tester.pumpWidget(harness(theme: AppTheme.dark()));
    await emit(tester, const Success<AuthUserEntity?>(googleUser));

    expect(find.text('Mariam Adel'), findsOneWidget);
    expect(find.text('jane@example.com'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('does not overflow at 1.5x text scale with long text', (
    tester,
  ) async {
    const longName = 'Abdelrahman Abdelrahman Abdelrahman Abdelrahman Example';

    await tester.pumpWidget(harness(textScaler: const TextScaler.linear(1.5)));
    await emit(
      tester,
      const Success<AuthUserEntity?>(
        AuthUserEntity(
          id: 'user-5',
          email: 'abdelrahman@example.com',
          displayName: longName,
        ),
      ),
    );

    expect(find.text(longName), findsOneWidget);
    expect(find.text('abdelrahman@example.com'), findsOneWidget);
  });

  testWidgets('exposes a signed-in semantic label', (tester) async {
    final semanticsHandle = tester.ensureSemantics();

    await tester.pumpWidget(harness());
    await emit(tester, const Success<AuthUserEntity?>(googleUser));

    expect(find.bySemanticsLabel('Signed in as Mariam Adel'), findsOneWidget);

    semanticsHandle.dispose();
  });

  testWidgets('exposes a guest semantic label', (tester) async {
    final semanticsHandle = tester.ensureSemantics();

    await tester.pumpWidget(harness());
    await emit(tester, const Success<AuthUserEntity?>(guestUser));

    expect(find.bySemanticsLabel('Signed in as guest'), findsOneWidget);

    semanticsHandle.dispose();
  });

  group('ProfileHeaderAvatar.initialsFor', () {
    test('takes the first letters of the first and last word', () {
      expect(ProfileHeaderAvatar.initialsFor('Mariam Adel'), 'MA');
      expect(ProfileHeaderAvatar.initialsFor('  Sara   Ali  '), 'SA');
    });

    test('returns a single letter for a single word', () {
      expect(ProfileHeaderAvatar.initialsFor('Mariam'), 'M');
    });

    test('handles Arabic names', () {
      expect(ProfileHeaderAvatar.initialsFor('محمد علي'), 'مع');
      expect(ProfileHeaderAvatar.initialsFor('محمد'), 'م');
    });

    test('returns empty for blank input', () {
      expect(ProfileHeaderAvatar.initialsFor(null), isEmpty);
      expect(ProfileHeaderAvatar.initialsFor(''), isEmpty);
      expect(ProfileHeaderAvatar.initialsFor('   '), isEmpty);
    });

    test('never splits an emoji surrogate pair', () {
      expect(ProfileHeaderAvatar.initialsFor('😀😀'), '😀');
    });
  });
}

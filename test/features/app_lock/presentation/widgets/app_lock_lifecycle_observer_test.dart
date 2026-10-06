import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_state.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_lifecycle_observer.dart';

import '../../../../helpers/app_lock_mocks.dart';

void main() {
  late MockGetAppLockEnabledUseCase getEnabled;
  late MockCheckDeviceLockAvailableUseCase checkAvailable;
  late MockAuthenticateDeviceUseCase authenticate;
  late MockSetRecentsPreviewHiddenUseCase setRecentsPreviewHidden;
  late AppLockCubit cubit;

  setUp(() {
    getEnabled = MockGetAppLockEnabledUseCase()..result = const Success(true);
    checkAvailable = MockCheckDeviceLockAvailableUseCase()
      ..result = const Success(true);
    authenticate = MockAuthenticateDeviceUseCase()
      ..result = const Success(AppLockStatus.authenticated);
    setRecentsPreviewHidden = MockSetRecentsPreviewHiddenUseCase();
    cubit = AppLockCubit(
      getEnabled,
      checkAvailable,
      authenticate,
      setRecentsPreviewHidden,
    );
  });

  tearDown(() => cubit.close());

  Future<void> pumpObserver(WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: const AppLockLifecycleObserver(child: SizedBox()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> sendState(WidgetTester tester, AppLifecycleState state) async {
    tester.binding.handleAppLifecycleStateChanged(state);
    await tester.pumpAndSettle();
  }

  testWidgets('evaluates the gate once on mount', (tester) async {
    await pumpObserver(tester);

    expect(cubit.state, isA<AppLockUnlocked>());
    expect(authenticate.reasons, hasLength(1));
  });

  testWidgets('inactive does not lock the app', (tester) async {
    await pumpObserver(tester);

    await sendState(tester, AppLifecycleState.inactive);

    expect(cubit.state, isA<AppLockUnlocked>());
  });

  testWidgets('paused locks and resumed re-authenticates', (tester) async {
    await pumpObserver(tester);
    expect(cubit.state, isA<AppLockUnlocked>());

    await sendState(tester, AppLifecycleState.paused);
    expect(cubit.state, isA<AppLockLocked>());

    await sendState(tester, AppLifecycleState.resumed);
    expect(cubit.state, isA<AppLockUnlocked>());
    expect(authenticate.reasons, hasLength(2));
  });

  testWidgets('hidden locks just like paused', (tester) async {
    await pumpObserver(tester);

    await sendState(tester, AppLifecycleState.hidden);
    expect(cubit.state, isA<AppLockLocked>());

    await sendState(tester, AppLifecycleState.resumed);
    expect(cubit.state, isA<AppLockUnlocked>());
  });

  testWidgets('a cancelled prompt is not re-prompted by its own resume', (
    tester,
  ) async {
    final pending = Completer<ApiResult<AppLockStatus>>();
    authenticate.gate = pending;
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: const AppLockLifecycleObserver(child: SizedBox()),
      ),
    );
    await tester.pump();
    expect(authenticate.reasons, hasLength(1));

    // The OS lifecycle sequence the prompt itself produces.
    await sendState(tester, AppLifecycleState.inactive);
    await sendState(tester, AppLifecycleState.paused);
    await sendState(tester, AppLifecycleState.hidden);
    await sendState(tester, AppLifecycleState.resumed);

    pending.complete(const Success(AppLockStatus.failed));
    await tester.pumpAndSettle();

    expect(
      authenticate.reasons,
      hasLength(1),
      reason: 'the app never really backgrounded, so it must not re-prompt',
    );
    expect(cubit.state, isA<AppLockLocked>());
  });

  testWidgets('the observer is removed when the widget is disposed', (
    tester,
  ) async {
    await pumpObserver(tester);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();

    await sendState(tester, AppLifecycleState.paused);

    expect(cubit.state, isA<AppLockUnlocked>());
  });
}

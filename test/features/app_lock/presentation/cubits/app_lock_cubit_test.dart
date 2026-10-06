import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_state.dart';

import '../../../../helpers/app_lock_mocks.dart';

void main() {
  late MockGetAppLockEnabledUseCase getEnabled;
  late MockCheckDeviceLockAvailableUseCase checkAvailable;
  late MockAuthenticateDeviceUseCase authenticate;
  late MockSetRecentsPreviewHiddenUseCase setRecentsPreviewHidden;
  late AppLockCubit cubit;

  setUp(() {
    getEnabled = MockGetAppLockEnabledUseCase();
    checkAvailable = MockCheckDeviceLockAvailableUseCase();
    authenticate = MockAuthenticateDeviceUseCase();
    setRecentsPreviewHidden = MockSetRecentsPreviewHiddenUseCase();
    cubit = AppLockCubit(
      getEnabled,
      checkAvailable,
      authenticate,
      setRecentsPreviewHidden,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('AppLockCubit gate evaluation', () {
    test('initial state is AppLockInitial and the gate is closed', () {
      expect(cubit.state, isA<AppLockInitial>());
      expect(cubit.isLocked, isTrue);
    });

    test(
      'emits Checking then Unlocked when enabled with a device lock',
      () async {
        final future = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<AppLockChecking>(),
            isA<AppLockLocked>().having(
              (s) => s.reason,
              'reason',
              AppLockLockedReason.prompt,
            ),
            isA<AppLockUnlocked>(),
          ]),
        );
        unawaited(cubit.onAppResumed());
        await future;

        expect(authenticate.reasons, hasLength(1));
        expect(cubit.isLocked, isFalse);
      },
    );

    test('emits Disabled without prompting when the setting is off', () async {
      getEnabled.result = const Success(false);

      final future = expectLater(
        cubit.stream,
        emitsInOrder([isA<AppLockChecking>(), isA<AppLockDisabled>()]),
      );
      unawaited(cubit.onAppResumed());
      await future;

      expect(authenticate.reasons, isEmpty);
      expect(checkAvailable.calls, 0);
      expect(cubit.isLocked, isFalse);
    });

    test(
      'emits Unlocked without prompting when the device has no lock',
      () async {
        checkAvailable.result = const Success(false);

        final future = expectLater(
          cubit.stream,
          emitsInOrder([isA<AppLockChecking>(), isA<AppLockUnlocked>()]),
        );
        unawaited(cubit.onAppResumed());
        await future;

        expect(authenticate.reasons, isEmpty);
        expect(cubit.isLocked, isFalse);
      },
    );

    test('emits Locked(cancelled) when the user cancels the prompt', () async {
      authenticate.result = const Success(AppLockStatus.failed);

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AppLockChecking>(),
          isA<AppLockLocked>().having(
            (s) => s.reason,
            'reason',
            AppLockLockedReason.prompt,
          ),
          isA<AppLockLocked>().having(
            (s) => s.reason,
            'reason',
            AppLockLockedReason.cancelled,
          ),
        ]),
      );
      unawaited(cubit.onAppResumed());
      await future;

      expect(cubit.isLocked, isTrue);
    });

    test(
      'emits Locked(lockedOut) when the OS locks out further attempts',
      () async {
        authenticate.result = const Success(AppLockStatus.lockedOut);

        final future = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<AppLockChecking>(),
            isA<AppLockLocked>().having(
              (s) => s.reason,
              'reason',
              AppLockLockedReason.prompt,
            ),
            isA<AppLockLocked>().having(
              (s) => s.reason,
              'reason',
              AppLockLockedReason.lockedOut,
            ),
          ]),
        );
        unawaited(cubit.onAppResumed());
        await future;

        expect(cubit.isLocked, isTrue);
      },
    );

    test(
      'emits Error and keeps the gate closed when the flag read fails',
      () async {
        getEnabled.result = const ResultFailure(CacheFailure());

        final future = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<AppLockChecking>(),
            isA<AppLockError>().having(
              (s) => s.failure,
              'failure',
              isA<CacheFailure>(),
            ),
          ]),
        );
        unawaited(cubit.onAppResumed());
        await future;

        expect(cubit.isLocked, isTrue);
      },
    );

    test(
      'emits Error and keeps the gate closed when auth fails unexpectedly',
      () async {
        authenticate.result = const ResultFailure(LocalAuthUnknownFailure());

        final future = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<AppLockChecking>(),
            isA<AppLockLocked>(),
            isA<AppLockError>(),
          ]),
        );
        unawaited(cubit.onAppResumed());
        await future;

        expect(cubit.isLocked, isTrue);
      },
    );
  });

  group('AppLockCubit lifecycle', () {
    test('backgrounding re-locks after a successful unlock', () async {
      await cubit.onAppResumed();
      expect(cubit.state, isA<AppLockUnlocked>());

      final future = expectLater(
        cubit.stream,
        emits(
          isA<AppLockLocked>().having(
            (s) => s.reason,
            'reason',
            AppLockLockedReason.prompt,
          ),
        ),
      );
      cubit.onAppPaused();
      await future;

      expect(cubit.isLocked, isTrue);
    });

    test('backgrounding while disabled does not lock', () async {
      getEnabled.result = const Success(false);
      await cubit.onAppResumed();
      expect(cubit.state, isA<AppLockDisabled>());

      final future = expectLater(cubit.stream, emitsDone);
      cubit.onAppPaused();
      await cubit.close();
      await future;
    });

    test(
      'a second resume while the OS prompt is in progress is ignored',
      () async {
        final future = expectLater(
          cubit.stream,
          emitsInOrder([
            isA<AppLockChecking>(),
            isA<AppLockLocked>(),
            isA<AppLockUnlocked>(),
          ]),
        );
        final first = cubit.onAppResumed();
        final second = cubit.onAppResumed();
        await Future.wait([first, second]);
        await future;

        expect(authenticate.reasons, hasLength(1));
      },
    );

    test(
      'resumes after a successful unlock never re-prompt or re-lock',
      () async {
        await cubit.onAppResumed();
        expect(cubit.state, isA<AppLockUnlocked>());
        expect(authenticate.reasons, hasLength(1));

        final emissions = cubit.stream.toList();
        await cubit.onAppResumed();
        await cubit.onAppResumed();
        await cubit.close();

        expect(await emissions, isEmpty);
        expect(authenticate.reasons, hasLength(1));
      },
    );

    test('a resume after backgrounding locks, then prompts once', () async {
      await cubit.onAppResumed();
      expect(cubit.state, isA<AppLockUnlocked>());

      cubit.onAppPaused();
      expect(cubit.isLocked, isTrue);

      final future = expectLater(cubit.stream, emits(isA<AppLockUnlocked>()));
      await cubit.onAppResumed();
      await future;

      expect(authenticate.reasons, hasLength(2));
    });

    test('a resume after a cancelled prompt does not prompt again', () async {
      authenticate.result = const Success(AppLockStatus.failed);
      await cubit.onAppResumed();
      expect(cubit.state, isA<AppLockLocked>());

      authenticate.result = const Success(AppLockStatus.authenticated);
      final emissions = cubit.stream.toList();
      await cubit.onAppResumed();
      await cubit.onAppResumed();
      await cubit.close();

      expect(await emissions, isEmpty);
      expect(authenticate.reasons, hasLength(1));
      expect(cubit.isLocked, isTrue);
    });

    test('pause then resume prompts exactly once after a cancel', () async {
      authenticate.result = const Success(AppLockStatus.failed);
      await cubit.onAppResumed();
      expect(cubit.isLocked, isTrue);

      cubit.onAppPaused();

      authenticate.result = const Success(AppLockStatus.authenticated);
      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AppLockLocked>().having(
            (s) => s.reason,
            'reason',
            AppLockLockedReason.prompt,
          ),
          isA<AppLockUnlocked>(),
        ]),
      );
      await cubit.onAppResumed();
      await future;

      expect(authenticate.reasons, hasLength(2));
      expect(cubit.isLocked, isFalse);
    });

    test('pause then resume prompts exactly once after an unlock', () async {
      await cubit.onAppResumed();
      expect(cubit.state, isA<AppLockUnlocked>());
      expect(authenticate.reasons, hasLength(1));

      cubit.onAppPaused();
      expect(cubit.isLocked, isTrue);

      final future = expectLater(cubit.stream, emits(isA<AppLockUnlocked>()));
      await cubit.onAppResumed();
      await future;

      expect(authenticate.reasons, hasLength(2));
    });

    test(
      'a pause during our own prompt does not arm a second prompt',
      () async {
        final pending = Completer<ApiResult<AppLockStatus>>();
        authenticate.gate = pending;

        final evaluation = cubit.onAppResumed();
        await Future<void>.delayed(Duration.zero);
        expect(
          cubit.state,
          isA<AppLockLocked>().having(
            (s) => s.reason,
            'reason',
            AppLockLockedReason.prompt,
          ),
        );

        cubit.onAppPaused();
        authenticate.result = const Success(AppLockStatus.failed);
        authenticate.gate = null;
        pending.complete(const Success(AppLockStatus.failed));
        await evaluation;
        expect(
          cubit.state,
          isA<AppLockLocked>().having(
            (s) => s.reason,
            'reason',
            AppLockLockedReason.cancelled,
          ),
        );

        final emissions = cubit.stream.toList();
        await cubit.onAppResumed();
        await cubit.close();

        expect(await emissions, isEmpty);
        expect(authenticate.reasons, hasLength(1));
      },
    );

    test(
      'unlocking from the lock screen still prompts after a cancel',
      () async {
        authenticate.result = const Success(AppLockStatus.failed);
        await cubit.onAppResumed();
        expect(authenticate.reasons, hasLength(1));

        authenticate.result = const Success(AppLockStatus.authenticated);
        final future = expectLater(
          cubit.stream,
          emitsInOrder([isA<AppLockLocked>(), isA<AppLockUnlocked>()]),
        );
        await cubit.unlock();
        await future;

        expect(authenticate.reasons, hasLength(2));
      },
    );

    test('duringAuthentication suppresses the pause-driven re-lock', () async {
      await cubit.onAppResumed();
      expect(cubit.state, isA<AppLockUnlocked>());

      final emissions = cubit.stream.toList();
      final window = cubit.duringAuthentication(() async {
        cubit.onAppPaused();
        return null;
      });
      await window;
      await cubit.close();

      expect(await emissions, isEmpty);
      expect(cubit.state, isA<AppLockUnlocked>());
    });

    test('duringAuthentication suppresses a resume evaluation', () async {
      authenticate.result = const Success(AppLockStatus.failed);
      await cubit.onAppResumed();
      expect(cubit.isLocked, isTrue);

      final emissions = cubit.stream.toList();
      await cubit.duringAuthentication(cubit.onAppResumed);
      await cubit.close();

      expect(await emissions, isEmpty);
      expect(authenticate.reasons, hasLength(1));
    });

    test(
      'duringAuthentication releases its window when the action throws',
      () async {
        await cubit.onAppResumed();
        expect(cubit.state, isA<AppLockUnlocked>());

        await expectLater(
          cubit.duringAuthentication(
            () async => throw Exception('prompt died'),
          ),
          throwsA(isA<Exception>()),
        );

        cubit.onAppPaused();
        expect(cubit.isLocked, isTrue, reason: 'the window must not leak');
      },
    );

    test(
      'refresh updates the gate after a settings toggle without prompting',
      () async {
        await cubit.onAppResumed();
        expect(cubit.state, isA<AppLockUnlocked>());

        getEnabled.result = const Success(false);
        final future = expectLater(cubit.stream, emits(isA<AppLockDisabled>()));
        await cubit.refresh();
        await future;

        expect(authenticate.reasons, hasLength(1));
        expect(cubit.isLocked, isFalse);
      },
    );

    test('refresh is ignored while the gate is closed', () async {
      authenticate.result = const Success(AppLockStatus.failed);
      await cubit.onAppResumed();
      final emissions = cubit.stream.toList();

      await cubit.refresh();
      await cubit.close();

      expect(await emissions, isEmpty);
    });
  });

  group('AppLockCubit recents preview', () {
    test('defaults to fail-closed (true) at startup before evaluation', () {
      // The native side defaults to true to protect the app before Dart boots.
      // This ensures we do not leak the preview on a very early backgrounding.
      expect(setRecentsPreviewHidden.calls, isEmpty);
    });

    test(
      'policy is true when enabled + device lock, even while Unlocked',
      () async {
        await cubit.onAppResumed();
        expect(cubit.state, isA<AppLockUnlocked>());

        // The policy should be set to true because App Lock is enabled and
        // the device has a lock, regardless of the gate being open.
        expect(setRecentsPreviewHidden.calls, [true]);

        // Should not send on every emit
        final previousCallsCount = setRecentsPreviewHidden.calls.length;
        cubit.onAppPaused(); // This causes a state emit to AppLockLocked
        expect(setRecentsPreviewHidden.calls.length, previousCallsCount);
      },
    );

    test('policy is false when disabled', () async {
      getEnabled.result = const Success(false);
      await cubit.onAppResumed();
      expect(cubit.state, isA<AppLockDisabled>());

      expect(setRecentsPreviewHidden.calls, [false]);
    });

    test('policy is false when no device lock', () async {
      checkAvailable.result = const Success(false);
      await cubit.onAppResumed();
      expect(cubit.state, isA<AppLockUnlocked>());

      expect(setRecentsPreviewHidden.calls, [false]);
    });

    test('policy is updated when Settings toggles', () async {
      await cubit.onAppResumed(); // initial check, evaluates to true
      expect(setRecentsPreviewHidden.calls, [true]);

      getEnabled.result = const Success(false);
      await cubit.refresh(); // user disabled it in settings

      expect(setRecentsPreviewHidden.calls, [true, false]);
    });
  });
}

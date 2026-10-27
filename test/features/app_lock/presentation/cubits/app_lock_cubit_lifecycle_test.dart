import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_state.dart';

import 'app_lock_cubit_harness.dart';

/// Lifecycle: backgrounding re-locks, paused states do not re-prompt, and
/// resume evaluations are idempotent once unlocked.
void main() {
  late AppLockCubitHarness harness;

  setUp(() async {
    harness = await AppLockCubitHarness.create();
  });

  tearDown(() {
    harness.dispose();
  });

  group('AppLockCubit lifecycle', () {
    test('backgrounding re-locks after a successful unlock', () async {
      await harness.cubit.onAppResumed();
      expect(harness.cubit.state, isA<AppLockUnlocked>());

      final future = expectLater(
        harness.cubit.stream,
        emits(
          isA<AppLockLocked>().having(
            (s) => s.reason,
            'reason',
            AppLockLockedReason.prompt,
          ),
        ),
      );
      harness.cubit.onAppPaused();
      await future;

      expect(harness.cubit.isLocked, isTrue);
    });

    test('backgrounding while disabled does not lock', () async {
      harness.getEnabled.result = const Success(false);
      await harness.cubit.onAppResumed();
      expect(harness.cubit.state, isA<AppLockDisabled>());

      final future = expectLater(harness.cubit.stream, emitsDone);
      harness.cubit.onAppPaused();
      await harness.cubit.close();
      await future;
    });

    test(
      'a second resume while the OS prompt is in progress is ignored',
      () async {
        final future = expectLater(
          harness.cubit.stream,
          emitsInOrder([
            isA<AppLockChecking>(),
            isA<AppLockLocked>(),
            isA<AppLockUnlocked>(),
          ]),
        );
        final first = harness.cubit.onAppResumed();
        final second = harness.cubit.onAppResumed();
        await Future.wait<void>([first, second]);
        await future;

        expect(harness.authenticate.reasons, hasLength(1));
      },
    );

    test(
      'resumes after a successful unlock never re-prompt or re-lock',
      () async {
        await harness.cubit.onAppResumed();
        expect(harness.cubit.state, isA<AppLockUnlocked>());
        expect(harness.authenticate.reasons, hasLength(1));

        final emissions = harness.cubit.stream.toList();
        await harness.cubit.onAppResumed();
        await harness.cubit.onAppResumed();
        await harness.cubit.close();

        expect(await emissions, isEmpty);
        expect(harness.authenticate.reasons, hasLength(1));
      },
    );

    test('a resume after backgrounding locks, then prompts once', () async {
      await harness.cubit.onAppResumed();
      expect(harness.cubit.state, isA<AppLockUnlocked>());

      harness.cubit.onAppPaused();
      expect(harness.cubit.isLocked, isTrue);

      final future = expectLater(
        harness.cubit.stream,
        emits(isA<AppLockUnlocked>()),
      );
      await harness.cubit.onAppResumed();
      await future;

      expect(harness.authenticate.reasons, hasLength(2));
    });

    test('a resume after a cancelled prompt does not prompt again', () async {
      harness.authenticate.result = const Success(AppLockStatus.failed);
      await harness.cubit.onAppResumed();
      expect(harness.cubit.state, isA<AppLockLocked>());

      harness.authenticate.result = const Success(AppLockStatus.authenticated);
      final emissions = harness.cubit.stream.toList();
      await harness.cubit.onAppResumed();
      await harness.cubit.onAppResumed();
      await harness.cubit.close();

      expect(await emissions, isEmpty);
      expect(harness.authenticate.reasons, hasLength(1));
      expect(harness.cubit.isLocked, isTrue);
    });

    test('pause then resume prompts exactly once after a cancel', () async {
      harness.authenticate.result = const Success(AppLockStatus.failed);
      await harness.cubit.onAppResumed();
      expect(harness.cubit.isLocked, isTrue);

      harness.cubit.onAppPaused();

      harness.authenticate.result = const Success(AppLockStatus.authenticated);
      final future = expectLater(
        harness.cubit.stream,
        emitsInOrder([
          isA<AppLockLocked>().having(
            (s) => s.reason,
            'reason',
            AppLockLockedReason.prompt,
          ),
          isA<AppLockUnlocked>(),
        ]),
      );
      await harness.cubit.onAppResumed();
      await future;

      expect(harness.authenticate.reasons, hasLength(2));
      expect(harness.cubit.isLocked, isFalse);
    });

    test('pause then resume prompts exactly once after an unlock', () async {
      await harness.cubit.onAppResumed();
      expect(harness.cubit.state, isA<AppLockUnlocked>());
      expect(harness.authenticate.reasons, hasLength(1));

      harness.cubit.onAppPaused();
      expect(harness.cubit.isLocked, isTrue);

      final future = expectLater(
        harness.cubit.stream,
        emits(isA<AppLockUnlocked>()),
      );
      await harness.cubit.onAppResumed();
      await future;

      expect(harness.authenticate.reasons, hasLength(2));
    });

    test(
      'a pause during our own prompt does not arm a second prompt',
      () async {
        final pending = Completer<ApiResult<AppLockStatus>>();
        harness.authenticate.gate = pending;

        final evaluation = harness.cubit.onAppResumed();
        await Future<void>.delayed(Duration.zero);
        expect(
          harness.cubit.state,
          isA<AppLockLocked>().having(
            (s) => s.reason,
            'reason',
            AppLockLockedReason.prompt,
          ),
        );

        harness.cubit.onAppPaused();
        harness.authenticate.result = const Success(AppLockStatus.failed);
        harness.authenticate.gate = null;
        pending.complete(const Success(AppLockStatus.failed));
        await evaluation;
        expect(
          harness.cubit.state,
          isA<AppLockLocked>().having(
            (s) => s.reason,
            'reason',
            AppLockLockedReason.cancelled,
          ),
        );

        final emissions = harness.cubit.stream.toList();
        await harness.cubit.onAppResumed();
        await harness.cubit.close();

        expect(await emissions, isEmpty);
        expect(harness.authenticate.reasons, hasLength(1));
      },
    );

    test(
      'unlocking from the lock screen still prompts after a cancel',
      () async {
        harness.authenticate.result = const Success(AppLockStatus.failed);
        await harness.cubit.onAppResumed();
        expect(harness.authenticate.reasons, hasLength(1));

        harness.authenticate.result = const Success(
          AppLockStatus.authenticated,
        );
        final future = expectLater(
          harness.cubit.stream,
          emitsInOrder([isA<AppLockLocked>(), isA<AppLockUnlocked>()]),
        );
        await harness.cubit.unlock();
        await future;

        expect(harness.authenticate.reasons, hasLength(2));
      },
    );
  });
}

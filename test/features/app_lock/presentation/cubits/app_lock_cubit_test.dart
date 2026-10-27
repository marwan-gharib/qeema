import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_state.dart';

import 'app_lock_cubit_harness.dart';

/// Gate evaluation: resume starts checking, then the gate opens, locks, or
/// errors based on the flag, the device lock, and the auth outcome.
void main() {
  late AppLockCubitHarness harness;

  setUp(() async {
    harness = await AppLockCubitHarness.create();
  });

  tearDown(() {
    harness.dispose();
  });

  group('AppLockCubit gate evaluation', () {
    test('initial state is AppLockInitial and the gate is closed', () {
      expect(harness.cubit.state, isA<AppLockInitial>());
      expect(harness.cubit.isLocked, isTrue);
    });

    test(
      'emits Checking then Unlocked when enabled with a device lock',
      () async {
        final future = expectLater(
          harness.cubit.stream,
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
        unawaited(harness.cubit.onAppResumed());
        await future;

        expect(harness.authenticate.reasons, hasLength(1));
        expect(harness.cubit.isLocked, isFalse);
      },
    );

    test('emits Disabled without prompting when the setting is off', () async {
      harness.getEnabled.result = const Success(false);

      final future = expectLater(
        harness.cubit.stream,
        emitsInOrder([isA<AppLockChecking>(), isA<AppLockDisabled>()]),
      );
      unawaited(harness.cubit.onAppResumed());
      await future;

      expect(harness.authenticate.reasons, isEmpty);
      expect(harness.checkAvailable.calls, 0);
      expect(harness.cubit.isLocked, isFalse);
    });

    test(
      'emits Unlocked without prompting when the device has no lock',
      () async {
        harness.checkAvailable.result = const Success(false);

        final future = expectLater(
          harness.cubit.stream,
          emitsInOrder([isA<AppLockChecking>(), isA<AppLockUnlocked>()]),
        );
        unawaited(harness.cubit.onAppResumed());
        await future;

        expect(harness.authenticate.reasons, isEmpty);
        expect(harness.cubit.isLocked, isFalse);
      },
    );

    test('emits Locked(cancelled) when the user cancels the prompt', () async {
      harness.authenticate.result = const Success(AppLockStatus.failed);

      final future = expectLater(
        harness.cubit.stream,
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
      unawaited(harness.cubit.onAppResumed());
      await future;

      expect(harness.cubit.isLocked, isTrue);
    });

    test(
      'emits Locked(lockedOut) when the OS locks out further attempts',
      () async {
        harness.authenticate.result = const Success(AppLockStatus.lockedOut);

        final future = expectLater(
          harness.cubit.stream,
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
        unawaited(harness.cubit.onAppResumed());
        await future;

        expect(harness.cubit.isLocked, isTrue);
      },
    );

    test(
      'emits Error and keeps the gate closed when the flag read fails',
      () async {
        harness.getEnabled.result = const ResultFailure(CacheFailure());

        final future = expectLater(
          harness.cubit.stream,
          emitsInOrder([
            isA<AppLockChecking>(),
            isA<AppLockError>().having(
              (s) => s.failure,
              'failure',
              isA<CacheFailure>(),
            ),
          ]),
        );
        unawaited(harness.cubit.onAppResumed());
        await future;

        expect(harness.cubit.isLocked, isTrue);
      },
    );

    test(
      'emits Error and keeps the gate closed when auth fails unexpectedly',
      () async {
        harness.authenticate.result = const ResultFailure(
          LocalAuthUnknownFailure(),
        );

        final future = expectLater(
          harness.cubit.stream,
          emitsInOrder([
            isA<AppLockChecking>(),
            isA<AppLockLocked>(),
            isA<AppLockError>(),
          ]),
        );
        unawaited(harness.cubit.onAppResumed());
        await future;

        expect(harness.cubit.isLocked, isTrue);
      },
    );
  });
}

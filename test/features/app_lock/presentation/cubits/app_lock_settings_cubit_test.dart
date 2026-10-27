import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_state.dart';

import 'app_lock_settings_cubit_harness.dart';

/// Load behavior and explicit toggles on the settings cubit.
void main() {
  late AppLockSettingsCubitHarness harness;

  setUp(() {
    harness = AppLockSettingsCubitHarness.create();
  });

  tearDown(() {
    harness.dispose();
  });

  group('load', () {
    test('emits Loaded with the stored flag and device availability', () async {
      final future = expectLater(
        harness.cubit.stream,
        emitsInOrder([
          isA<AppLockSettingsLoading>(),
          isA<AppLockSettingsLoaded>()
              .having((s) => s.isEnabled, 'isEnabled', isTrue)
              .having((s) => s.deviceLockAvailable, 'available', isTrue),
        ]),
      );
      unawaited(harness.cubit.load());
      await future;
    });

    test('reflects a stored disabled flag', () async {
      harness.getEnabled.result = const Success(false);

      final future = expectLater(
        harness.cubit.stream,
        emitsInOrder([
          isA<AppLockSettingsLoading>(),
          isA<AppLockSettingsLoaded>().having(
            (s) => s.isEnabled,
            'isEnabled',
            isFalse,
          ),
        ]),
      );
      unawaited(harness.cubit.load());
      await future;
    });

    test('emits Failure when the flag read fails', () async {
      harness.getEnabled.result = const ResultFailure(CacheFailure());

      final future = expectLater(
        harness.cubit.stream,
        emitsInOrder([
          isA<AppLockSettingsLoading>(),
          isA<AppLockSettingsFailure>().having(
            (s) => s.failure,
            'failure',
            isA<CacheFailure>(),
          ),
        ]),
      );
      unawaited(harness.cubit.load());
      await future;
    });

    test('emits Failure when the device-lock check fails', () async {
      harness.checkAvailable.result = const ResultFailure(
        LocalAuthUnknownFailure(),
      );

      final future = expectLater(
        harness.cubit.stream,
        emitsInOrder([
          isA<AppLockSettingsLoading>(),
          isA<AppLockSettingsFailure>().having(
            (s) => s.failure,
            'failure',
            isA<LocalAuthUnknownFailure>(),
          ),
        ]),
      );
      unawaited(harness.cubit.load());
      await future;
    });
  });

  group('setEnabled', () {
    test('enabling persists immediately without authentication', () async {
      harness.getEnabled.result = const Success(false);
      await harness.cubit.load();

      final future = expectLater(
        harness.cubit.stream,
        emits(
          isA<AppLockSettingsLoaded>()
              .having((s) => s.isEnabled, 'isEnabled', isTrue)
              .having((s) => s.isBusy, 'isBusy', isFalse),
        ),
      );
      await harness.cubit.setEnabled(true);
      await future;

      expect(harness.setEnabled.calls, [true]);
      expect(harness.authenticate.reasons, isEmpty);
    });

    test('disabling authenticates first, then persists', () async {
      await harness.cubit.load();

      final future = expectLater(
        harness.cubit.stream,
        emitsInOrder([
          isA<AppLockSettingsLoaded>().having((s) => s.isBusy, 'busy', isTrue),
          isA<AppLockSettingsLoaded>()
              .having((s) => s.isEnabled, 'isEnabled', isFalse)
              .having((s) => s.isBusy, 'busy', isFalse),
        ]),
      );
      await harness.cubit.setEnabled(false);
      await future;

      expect(harness.authenticate.reasons, hasLength(1));
      expect(harness.setEnabled.calls, [false]);
    });

    test(
      'disabling keeps the switch on when the prompt is cancelled',
      () async {
        await harness.cubit.load();
        harness.authenticate.result = const Success(AppLockStatus.failed);

        final future = expectLater(
          harness.cubit.stream,
          emitsInOrder([
            isA<AppLockSettingsLoaded>().having(
              (s) => s.isBusy,
              'busy',
              isTrue,
            ),
            isA<AppLockSettingsLoaded>()
                .having((s) => s.isEnabled, 'isEnabled', isTrue)
                .having((s) => s.isBusy, 'busy', isFalse),
          ]),
        );
        await harness.cubit.setEnabled(false);
        await future;

        expect(harness.setEnabled.calls, isEmpty);
      },
    );

    test('disabling keeps the switch on when authentication fails', () async {
      await harness.cubit.load();
      harness.authenticate.result = const ResultFailure(
        LocalAuthUnknownFailure(),
      );

      await harness.cubit.setEnabled(false);

      expect(harness.setEnabled.calls, isEmpty);
      expect(harness.cubit.state, isA<AppLockSettingsLoaded>());
      final loaded = harness.cubit.state as AppLockSettingsLoaded;
      expect(loaded.isEnabled, isTrue);
      expect(loaded.isBusy, isFalse);
    });

    test('reverts when persistence fails', () async {
      harness.getEnabled.result = const Success(false);
      await harness.cubit.load();
      harness.setEnabled.result = const ResultFailure(CacheFailure());

      await harness.cubit.setEnabled(true);

      expect(harness.cubit.state, isA<AppLockSettingsLoaded>());
      final loaded = harness.cubit.state as AppLockSettingsLoaded;
      expect(loaded.isEnabled, isFalse);
      expect(loaded.isBusy, isFalse);
    });

    test('is ignored while still loading', () async {
      await harness.cubit.setEnabled(true);

      expect(harness.setEnabled.calls, isEmpty);
      expect(harness.cubit.state, isA<AppLockSettingsLoading>());
    });

    test('is ignored while a previous toggle is in flight', () async {
      await harness.cubit.load();
      harness.authenticate.result = const Success(AppLockStatus.failed);

      final first = harness.cubit.setEnabled(false);
      final second = harness.cubit.setEnabled(false);
      await Future.wait([first, second]);

      expect(harness.authenticate.reasons, hasLength(1));
      expect(harness.setEnabled.calls, isEmpty);
    });

    test('declines to disable when the OS reports no credentials', () async {
      await harness.cubit.load();
      harness.authenticate.result = const Success(AppLockStatus.notRequired);

      await harness.cubit.setEnabled(false);

      expect(harness.setEnabled.calls, isEmpty);
      expect((harness.cubit.state as AppLockSettingsLoaded).isEnabled, isTrue);
    });

    test('declines to disable on lockout', () async {
      await harness.cubit.load();
      harness.authenticate.result = const Success(AppLockStatus.lockedOut);

      await harness.cubit.setEnabled(false);

      expect(harness.setEnabled.calls, isEmpty);
      expect((harness.cubit.state as AppLockSettingsLoaded).isEnabled, isTrue);
    });
  });
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_state.dart';
import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_state.dart';

import '../../../../helpers/app_lock_mocks.dart';

void main() {
  late MockGetAppLockEnabledUseCase getEnabled;
  late MockSetAppLockEnabledUseCase setEnabled;
  late MockCheckDeviceLockAvailableUseCase checkAvailable;
  late MockAuthenticateDeviceUseCase authenticate;
  late SpyAppLockCubit appLock;
  late AppLockSettingsCubit cubit;

  setUp(() {
    getEnabled = MockGetAppLockEnabledUseCase();
    setEnabled = MockSetAppLockEnabledUseCase();
    checkAvailable = MockCheckDeviceLockAvailableUseCase();
    authenticate = MockAuthenticateDeviceUseCase();
    appLock = SpyAppLockCubit(
      getEnabled,
      checkAvailable,
      authenticate,
      MockSetRecentsPreviewHiddenUseCase(),
    );
    cubit = AppLockSettingsCubit(
      getEnabled,
      setEnabled,
      checkAvailable,
      authenticate,
      appLock,
    );
  });

  tearDown(() {
    cubit.close();
    appLock.close();
  });

  group('load', () {
    test('emits Loaded with the stored flag and device availability', () async {
      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AppLockSettingsLoading>(),
          isA<AppLockSettingsLoaded>()
              .having((s) => s.isEnabled, 'isEnabled', isTrue)
              .having((s) => s.deviceLockAvailable, 'available', isTrue),
        ]),
      );
      unawaited(cubit.load());
      await future;
    });

    test('reflects a stored disabled flag', () async {
      getEnabled.result = const Success(false);

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AppLockSettingsLoading>(),
          isA<AppLockSettingsLoaded>().having(
            (s) => s.isEnabled,
            'isEnabled',
            isFalse,
          ),
        ]),
      );
      unawaited(cubit.load());
      await future;
    });

    test('emits Failure when the flag read fails', () async {
      getEnabled.result = const ResultFailure(CacheFailure());

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AppLockSettingsLoading>(),
          isA<AppLockSettingsFailure>().having(
            (s) => s.failure,
            'failure',
            isA<CacheFailure>(),
          ),
        ]),
      );
      unawaited(cubit.load());
      await future;
    });

    test('emits Failure when the device-lock check fails', () async {
      checkAvailable.result = const ResultFailure(LocalAuthUnknownFailure());

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AppLockSettingsLoading>(),
          isA<AppLockSettingsFailure>().having(
            (s) => s.failure,
            'failure',
            isA<LocalAuthUnknownFailure>(),
          ),
        ]),
      );
      unawaited(cubit.load());
      await future;
    });
  });

  group('setEnabled', () {
    test('enabling persists immediately without authentication', () async {
      getEnabled.result = const Success(false);
      await cubit.load();

      final future = expectLater(
        cubit.stream,
        emits(
          isA<AppLockSettingsLoaded>()
              .having((s) => s.isEnabled, 'isEnabled', isTrue)
              .having((s) => s.isBusy, 'isBusy', isFalse),
        ),
      );
      await cubit.setEnabled(true);
      await future;

      expect(setEnabled.calls, [true]);
      expect(authenticate.reasons, isEmpty);
    });

    test('disabling authenticates first, then persists', () async {
      await cubit.load();

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AppLockSettingsLoaded>().having((s) => s.isBusy, 'busy', isTrue),
          isA<AppLockSettingsLoaded>()
              .having((s) => s.isEnabled, 'isEnabled', isFalse)
              .having((s) => s.isBusy, 'busy', isFalse),
        ]),
      );
      await cubit.setEnabled(false);
      await future;

      expect(authenticate.reasons, hasLength(1));
      expect(setEnabled.calls, [false]);
    });

    test(
      'disabling keeps the switch on when the prompt is cancelled',
      () async {
        await cubit.load();
        authenticate.result = const Success(AppLockStatus.failed);

        final future = expectLater(
          cubit.stream,
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
        await cubit.setEnabled(false);
        await future;

        expect(setEnabled.calls, isEmpty);
      },
    );

    test('disabling keeps the switch on when authentication fails', () async {
      await cubit.load();
      authenticate.result = const ResultFailure(LocalAuthUnknownFailure());

      await cubit.setEnabled(false);

      expect(setEnabled.calls, isEmpty);
      expect(cubit.state, isA<AppLockSettingsLoaded>());
      final loaded = cubit.state as AppLockSettingsLoaded;
      expect(loaded.isEnabled, isTrue);
      expect(loaded.isBusy, isFalse);
    });

    test('reverts when persistence fails', () async {
      getEnabled.result = const Success(false);
      await cubit.load();
      setEnabled.result = const ResultFailure(CacheFailure());

      await cubit.setEnabled(true);

      expect(cubit.state, isA<AppLockSettingsLoaded>());
      final loaded = cubit.state as AppLockSettingsLoaded;
      expect(loaded.isEnabled, isFalse);
      expect(loaded.isBusy, isFalse);
    });

    test('is ignored while still loading', () async {
      await cubit.setEnabled(true);

      expect(setEnabled.calls, isEmpty);
      expect(cubit.state, isA<AppLockSettingsLoading>());
    });

    test('is ignored while a previous toggle is in flight', () async {
      await cubit.load();
      authenticate.result = const Success(AppLockStatus.failed);

      final first = cubit.setEnabled(false);
      final second = cubit.setEnabled(false);
      await Future.wait([first, second]);

      expect(authenticate.reasons, hasLength(1));
      expect(setEnabled.calls, isEmpty);
    });

    test('declines to disable when the OS reports no credentials', () async {
      await cubit.load();
      authenticate.result = const Success(AppLockStatus.notRequired);

      await cubit.setEnabled(false);

      expect(setEnabled.calls, isEmpty);
      expect((cubit.state as AppLockSettingsLoaded).isEnabled, isTrue);
    });

    test('declines to disable on lockout', () async {
      await cubit.load();
      authenticate.result = const Success(AppLockStatus.lockedOut);

      await cubit.setEnabled(false);

      expect(setEnabled.calls, isEmpty);
      expect((cubit.state as AppLockSettingsLoaded).isEnabled, isTrue);
    });
  });

  group('setEnabled while the gate owns the prompt window', () {
    test('backgrounding during the Settings prompt does not re-lock', () async {
      await appLock.onAppResumed();
      expect(appLock.state, isA<AppLockUnlocked>());
      await cubit.load();

      final prompt = Completer<ApiResult<AppLockStatus>>();
      authenticate.gate = prompt;
      final toggling = cubit.setEnabled(false);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // The OS prompt pauses the activity while it is on screen.
      appLock.onAppPaused();
      expect(
        appLock.state,
        isA<AppLockUnlocked>(),
        reason: 'a Settings prompt must not re-lock the app underneath itself',
      );

      prompt.complete(const Success(AppLockStatus.authenticated));
      await toggling;
      expect(setEnabled.calls, [false]);
    });

    test('a foreground round trip during the Settings prompt does not prompt '
        'again', () async {
      authenticate.result = const Success(AppLockStatus.failed);
      await appLock.onAppResumed();
      expect(appLock.isLocked, isTrue);
      await cubit.load();

      final prompt = Completer<ApiResult<AppLockStatus>>();
      authenticate.gate = prompt;
      final toggling = cubit.setEnabled(false);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      appLock.onAppPaused();
      await appLock.onAppResumed();

      prompt.complete(const Success(AppLockStatus.authenticated));
      await toggling;
      expect(authenticate.reasons, hasLength(2));
    });

    test(
      'does not emit after the router closed the cubit mid-prompt',
      () async {
        await cubit.load();

        final prompt = Completer<ApiResult<AppLockStatus>>();
        authenticate.gate = prompt;
        final toggling = cubit.setEnabled(false);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        await cubit.close();
        prompt.complete(const Success(AppLockStatus.authenticated));
        await toggling;

        expect(setEnabled.calls, isEmpty);
      },
    );

    test('does not emit after the router closed the cubit mid-load', () async {
      final cubitToClose = AppLockSettingsCubit(
        getEnabled,
        setEnabled,
        checkAvailable,
        authenticate,
        appLock,
      );
      await cubitToClose.close();

      await cubitToClose.load();
      await cubitToClose.setEnabled(true);
    });
  });
}

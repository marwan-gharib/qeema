import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_state.dart';
import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_cubit.dart';

import 'app_lock_settings_cubit_harness.dart';

/// Settings toggles while the app-lock gate owns the prompt window: the
/// Settings prompt must not re-lock the app underneath itself, and a cubit
/// closed mid-prompt must not emit.
void main() {
  late AppLockSettingsCubitHarness harness;

  setUp(() {
    harness = AppLockSettingsCubitHarness.create();
  });

  tearDown(() {
    harness.dispose();
  });

  group('setEnabled while the gate owns the prompt window', () {
    test('backgrounding during the Settings prompt does not re-lock', () async {
      await harness.appLock.onAppResumed();
      expect(harness.appLock.state, isA<AppLockUnlocked>());
      await harness.cubit.load();

      final prompt = Completer<ApiResult<AppLockStatus>>();
      harness.authenticate.gate = prompt;
      final toggling = harness.cubit.setEnabled(false);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // The OS prompt pauses the activity while it is on screen.
      harness.appLock.onAppPaused();
      expect(
        harness.appLock.state,
        isA<AppLockUnlocked>(),
        reason: 'a Settings prompt must not re-lock the app underneath itself',
      );

      prompt.complete(const Success(AppLockStatus.authenticated));
      await toggling;
      expect(harness.setEnabled.calls, [false]);
    });

    test('a foreground round trip during the Settings prompt does not prompt '
        'again', () async {
      harness.authenticate.result = const Success(AppLockStatus.failed);
      await harness.appLock.onAppResumed();
      expect(harness.appLock.isLocked, isTrue);
      await harness.cubit.load();

      final prompt = Completer<ApiResult<AppLockStatus>>();
      harness.authenticate.gate = prompt;
      final toggling = harness.cubit.setEnabled(false);
      await Future<void>.delayed(const Duration(milliseconds: 10));

      harness.appLock.onAppPaused();
      await harness.appLock.onAppResumed();

      prompt.complete(const Success(AppLockStatus.authenticated));
      await toggling;
      expect(harness.authenticate.reasons, hasLength(2));
    });

    test(
      'does not emit after the router closed the cubit mid-prompt',
      () async {
        await harness.cubit.load();

        final prompt = Completer<ApiResult<AppLockStatus>>();
        harness.authenticate.gate = prompt;
        final toggling = harness.cubit.setEnabled(false);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        await harness.cubit.close();
        prompt.complete(const Success(AppLockStatus.authenticated));
        await toggling;

        expect(harness.setEnabled.calls, isEmpty);
      },
    );

    test('does not emit after the router closed the cubit mid-load', () async {
      final cubitToClose = AppLockSettingsCubit(
        harness.getEnabled,
        harness.setEnabled,
        harness.checkAvailable,
        harness.authenticate,
        harness.appLock,
      );
      await cubitToClose.close();

      await cubitToClose.load();
      await cubitToClose.setEnabled(true);
    });
  });
}

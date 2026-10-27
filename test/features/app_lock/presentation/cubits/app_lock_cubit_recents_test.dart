import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_state.dart';

import 'app_lock_cubit_harness.dart';

/// Recents-preview policy: fail-closed at startup, true when enabled with a
/// device lock, false when disabled or lockless, and updated on Settings
/// toggles.
void main() {
  late AppLockCubitHarness harness;

  setUp(() async {
    harness = await AppLockCubitHarness.create();
  });

  tearDown(() {
    harness.dispose();
  });

  group('AppLockCubit recents preview', () {
    test('defaults to fail-closed (true) at startup before evaluation', () {
      // The native side defaults to true to protect the app before Dart boots.
      // This ensures we do not leak the preview on a very early backgrounding.
      expect(harness.setRecentsPreviewHidden.calls, isEmpty);
    });

    test(
      'policy is true when enabled + device lock, even while Unlocked',
      () async {
        await harness.cubit.onAppResumed();
        expect(harness.cubit.state, isA<AppLockUnlocked>());

        // The policy should be set to true because App Lock is enabled and
        // the device has a lock, regardless of the gate being open.
        expect(harness.setRecentsPreviewHidden.calls, [true]);

        // Should not send on every emit
        final previousCallsCount = harness.setRecentsPreviewHidden.calls.length;
        harness.cubit
            .onAppPaused(); // This causes a state emit to AppLockLocked
        expect(
          harness.setRecentsPreviewHidden.calls.length,
          previousCallsCount,
        );
      },
    );

    test('policy is false when disabled', () async {
      harness.getEnabled.result = const Success(false);
      await harness.cubit.onAppResumed();
      expect(harness.cubit.state, isA<AppLockDisabled>());

      expect(harness.setRecentsPreviewHidden.calls, [false]);
    });

    test('policy is false when no device lock', () async {
      harness.checkAvailable.result = const Success(false);
      await harness.cubit.onAppResumed();
      expect(harness.cubit.state, isA<AppLockUnlocked>());

      expect(harness.setRecentsPreviewHidden.calls, [false]);
    });

    test('policy is updated when Settings toggles', () async {
      await harness.cubit.onAppResumed(); // initial check, evaluates to true
      expect(harness.setRecentsPreviewHidden.calls, [true]);

      harness.getEnabled.result = const Success(false);
      await harness.cubit.refresh(); // user disabled it in settings

      expect(harness.setRecentsPreviewHidden.calls, [true, false]);
    });
  });
}

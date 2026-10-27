import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_state.dart';

import 'app_lock_cubit_harness.dart';

/// duringAuthentication suppresses pause-driven re-lock, resume evaluation,
/// and releases its window when the action throws. refresh updates the gate
/// after a settings toggle without prompting, and is ignored while locked.
void main() {
  late AppLockCubitHarness harness;

  setUp(() async {
    harness = await AppLockCubitHarness.create();
  });

  tearDown(() {
    harness.dispose();
  });

  group('AppLockCubit duringAuthentication', () {
    test('suppresses the pause-driven re-lock', () async {
      await harness.cubit.onAppResumed();
      expect(harness.cubit.state, isA<AppLockUnlocked>());

      final emissions = harness.cubit.stream.toList();
      final window = harness.cubit.duringAuthentication(() async {
        harness.cubit.onAppPaused();
        return null;
      });
      await window;
      await harness.cubit.close();

      expect(await emissions, isEmpty);
      expect(harness.cubit.state, isA<AppLockUnlocked>());
    });

    test('suppresses a resume evaluation', () async {
      harness.authenticate.result = const Success(AppLockStatus.failed);
      await harness.cubit.onAppResumed();
      expect(harness.cubit.isLocked, isTrue);

      final emissions = harness.cubit.stream.toList();
      await harness.cubit.duringAuthentication(harness.cubit.onAppResumed);
      await harness.cubit.close();

      expect(await emissions, isEmpty);
      expect(harness.authenticate.reasons, hasLength(1));
    });

    test('releases its window when the action throws', () async {
      await harness.cubit.onAppResumed();
      expect(harness.cubit.state, isA<AppLockUnlocked>());

      await expectLater(
        harness.cubit.duringAuthentication(
          () async => throw Exception('prompt died'),
        ),
        throwsA(isA<Exception>()),
      );

      harness.cubit.onAppPaused();
      expect(
        harness.cubit.isLocked,
        isTrue,
        reason: 'the window must not leak',
      );
    });
  });

  group('AppLockCubit refresh', () {
    test(
      'updates the gate after a settings toggle without prompting',
      () async {
        await harness.cubit.onAppResumed();
        expect(harness.cubit.state, isA<AppLockUnlocked>());

        harness.getEnabled.result = const Success(false);
        final future = expectLater(
          harness.cubit.stream,
          emits(isA<AppLockDisabled>()),
        );
        await harness.cubit.refresh();
        await future;

        expect(harness.authenticate.reasons, hasLength(1));
        expect(harness.cubit.isLocked, isFalse);
      },
    );

    test('is ignored while the gate is closed', () async {
      harness.authenticate.result = const Success(AppLockStatus.failed);
      await harness.cubit.onAppResumed();
      final emissions = harness.cubit.stream.toList();

      await harness.cubit.refresh();
      await harness.cubit.close();

      expect(await emissions, isEmpty);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/app_lock/domain/entities/app_lock_status.dart';

import 'settings_screen_harness.dart';

/// The security section, driven through the whole screen: turning the app lock
/// off authenticates first, turning it on does not, and a device without a
/// lock gets a disabled switch with an explanation.
void main() {
  late SettingsScreenHarness harness;

  setUp(() async {
    harness = await SettingsScreenHarness.create();
  });

  tearDown(() {
    harness.dispose();
  });

  testWidgets('turning app lock off authenticates first, then persists and '
      'refreshes the gate', (tester) async {
    await tester.pumpWidget(harness.build());
    await harness.settle(tester);

    final toggle = find.byType(Switch);
    expect(tester.widget<Switch>(toggle).value, isTrue);

    await tester.ensureVisible(toggle);
    await tester.pump();
    await tester.tap(toggle);
    await tester.pumpAndSettle();

    expect(harness.authenticateDevice.reasons, hasLength(1));
    expect(harness.setAppLockEnabled.calls, [false]);
    expect(harness.appLockCubit.refreshCalls, 1);
    expect(tester.widget<Switch>(toggle).value, isFalse);
  });

  testWidgets('turning app lock off keeps the switch on when the user '
      'cancels the prompt', (tester) async {
    harness.authenticateDevice.result = const Success(AppLockStatus.failed);
    await tester.pumpWidget(harness.build());
    await harness.settle(tester);

    final toggle = find.byType(Switch);
    await tester.ensureVisible(toggle);
    await tester.pump();
    await tester.tap(toggle);
    await tester.pumpAndSettle();

    expect(harness.setAppLockEnabled.calls, isEmpty);
    expect(tester.widget<Switch>(toggle).value, isTrue);
  });

  testWidgets('disables the switch with an explanation when the device has '
      'no lock', (tester) async {
    harness.checkDeviceLockAvailable.result = const Success(false);
    await harness.appLockSettingsCubit.load();
    await tester.pumpWidget(harness.build());
    await harness.settle(tester);

    expect(
      find.text(
        'Set a screen lock (PIN, pattern, or password) in system settings '
        'to use App Lock',
      ),
      findsOneWidget,
    );
    expect(tester.widget<Switch>(find.byType(Switch)).onChanged, isNull);

    await tester.ensureVisible(find.byType(Switch));
    await tester.pump();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(harness.authenticateDevice.reasons, isEmpty);
    expect(harness.setAppLockEnabled.calls, isEmpty);
  });

  testWidgets('turning app lock on persists without authentication', (
    tester,
  ) async {
    harness.setAppLockEnabled.calls.clear();
    harness.authenticateDevice.reasons.clear();
    harness.getAppLockEnabled.result = const Success(false);
    await harness.appLockSettingsCubit.load();
    await tester.pumpWidget(harness.build());
    await harness.settle(tester);
    final toggle = find.byType(Switch);
    expect(tester.widget<Switch>(toggle).value, isFalse);

    await tester.ensureVisible(toggle);
    await tester.pump();
    await tester.tap(toggle);
    await tester.pumpAndSettle();

    expect(harness.authenticateDevice.reasons, isEmpty);
    expect(harness.setAppLockEnabled.calls, [true]);
    expect(tester.widget<Switch>(toggle).value, isTrue);
  });
}

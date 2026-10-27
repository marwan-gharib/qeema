import 'package:flutter_test/flutter_test.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_text_field.dart';

import 'settings_screen_harness.dart';

/// The danger-zone section: both destructive flows land on the welcome route.
void main() {
  late SettingsScreenHarness harness;

  setUp(() async {
    harness = await SettingsScreenHarness.create();
  });

  tearDown(() {
    harness.dispose();
  });

  testWidgets('deleting the account navigates to welcome on success', (
    tester,
  ) async {
    await tester.pumpWidget(harness.build());
    await harness.settle(tester);

    await tester.ensureVisible(find.text('Delete Account'));
    await tester.pump();
    await tester.tap(find.text('Delete Account'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(AppTextField), 'DELETE');
    await tester.pump();
    await tester.tap(find.widgetWithText(AppButton, 'Delete Forever'));
    await tester.pumpAndSettle();

    expect(harness.deleteUseCase.calls, 1);
    expect(find.text('Welcome Stub'), findsOneWidget);
  });

  testWidgets('logging out as Google user navigates to welcome', (
    tester,
  ) async {
    await tester.pumpWidget(harness.build());
    await harness.settle(tester);

    await tester.ensureVisible(find.text('Log Out'));
    await tester.pump();
    await tester.tap(find.text('Log Out'));
    await tester.pumpAndSettle();

    expect(find.text('Log Out?'), findsOneWidget);
    await tester.tap(find.widgetWithText(AppButton, 'Log Out'));
    await tester.pumpAndSettle();

    expect(harness.logoutUseCase.calls, 1);
    expect(find.text('Welcome Stub'), findsOneWidget);
  });
}

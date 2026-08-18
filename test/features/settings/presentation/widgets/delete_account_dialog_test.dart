import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_text_field.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_state.dart';
import 'package:qeema/features/settings/presentation/widgets/delete_account_dialog.dart';

import '../../../../helpers/settings_mocks.dart';

Widget _harness(DeleteAccountCubit cubit) {
  return TranslationProvider(
    child: BlocProvider<DeleteAccountCubit>.value(
      value: cubit,
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => DeleteAccountDialog.show(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _openDialog(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

Future<void> _typeConfirmation(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(AppTextField), text);
  await tester.pump();
}

void main() {
  late MockDeleteAccountUseCase useCase;
  late DeleteAccountCubit cubit;

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
    useCase = MockDeleteAccountUseCase();
    cubit = DeleteAccountCubit(useCase);
  });

  tearDown(() => cubit.close());

  testWidgets('renders the dialog copy', (tester) async {
    await tester.pumpWidget(_harness(cubit));
    await _openDialog(tester);

    expect(find.text('Delete Account?'), findsOneWidget);
    expect(find.text('Type DELETE to confirm'), findsOneWidget);
    expect(find.text('Delete Forever'), findsOneWidget);
  });

  testWidgets('confirmation button stays disabled until DELETE is typed', (
    tester,
  ) async {
    await tester.pumpWidget(_harness(cubit));
    await _openDialog(tester);
    final button = find.widgetWithText(AppButton, 'Delete Forever');

    await _typeConfirmation(tester, 'delete');
    await tester.tap(button);
    await tester.pump();

    expect(useCase.calls, 0);
    expect(tester.widget<AppButton>(button).onPressed, isNull);

    await _typeConfirmation(
      tester,
      AppConstants.deleteAccountConfirmationPhrase,
    );

    expect(tester.widget<AppButton>(button).onPressed, isNotNull);
  });

  testWidgets('typing DELETE and confirming invokes the cubit and closes', (
    tester,
  ) async {
    await tester.pumpWidget(_harness(cubit));
    await _openDialog(tester);

    await _typeConfirmation(
      tester,
      AppConstants.deleteAccountConfirmationPhrase,
    );
    await tester.tap(find.widgetWithText(AppButton, 'Delete Forever'));
    await tester.pumpAndSettle();

    expect(useCase.calls, 1);
    expect(cubit.state, isA<DeleteAccountSuccess>());
    expect(find.byType(DeleteAccountDialog), findsNothing);
  });

  testWidgets('shows the generic failure message', (tester) async {
    useCase.result = const ResultFailure(AccountDeletionFailure());
    await tester.pumpWidget(_harness(cubit));
    await _openDialog(tester);

    await _typeConfirmation(
      tester,
      AppConstants.deleteAccountConfirmationPhrase,
    );
    await tester.tap(find.widgetWithText(AppButton, 'Delete Forever'));
    await tester.pumpAndSettle();

    expect(
      find.text('Could not delete your account. Please try again.'),
      findsOneWidget,
    );
  });

  testWidgets('shows the partial failure message', (tester) async {
    useCase.result = const ResultFailure(AccountDeletionPartialFailure());
    await tester.pumpWidget(_harness(cubit));
    await _openDialog(tester);

    await _typeConfirmation(
      tester,
      AppConstants.deleteAccountConfirmationPhrase,
    );
    await tester.tap(find.widgetWithText(AppButton, 'Delete Forever'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Your data was deleted but your account could not be fully removed. '
        'Please try again or contact support.',
      ),
      findsOneWidget,
    );
  });
}

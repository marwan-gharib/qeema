import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/constants/app_constants.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_snackbar.dart';
import 'package:qeema/core/widgets/app_text_field.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_state.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const DeleteAccountDialog(),
    );
  }

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _controller = TextEditingController();
  var _confirmationMatches = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
      listener: (context, state) {
        switch (state) {
          case DeleteAccountInitial():
          case DeleteAccountDeleting():
            break;
          case DeleteAccountSuccess():
            Navigator.pop(context);
          case DeleteAccountFailure(:final failure):
            final message = switch (failure) {
              final AccountDeletionPartialFailure _ =>
                t.settings.deletePartialFailure,
              _ => t.settings.deleteFailed,
            };
            AppSnackBar.showError(context, message);
        }
      },
      builder: (context, state) {
        final isDeleting = state is DeleteAccountDeleting;
        final canDelete = _confirmationMatches && !isDeleting;

        return AlertDialog(
          title: Text(t.settings.deleteDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.settings.deleteDialogBody),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _controller,
                hint: t.settings.deleteConfirmHint,
                enabled: !isDeleting,
                onChanged: (value) => setState(
                  () => _confirmationMatches =
                      value == AppConstants.deleteAccountConfirmationPhrase,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isDeleting ? null : () => Navigator.pop(context),
              child: Text(t.core.actions.cancel),
            ),
            AppButton(
              label: t.settings.deleteForever,
              isLoading: isDeleting,
              onPressed: canDelete
                  ? () => context.read<DeleteAccountCubit>().deleteAccount()
                  : null,
            ),
          ],
        );
      },
    );
  }
}

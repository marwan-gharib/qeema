import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_snackbar.dart';
import 'package:qeema/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/logout_cubit/logout_state.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key, required this.isGuest});

  final bool isGuest;

  static Future<void> show(BuildContext context, {required bool isGuest}) {
    return showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<LogoutCubit>(),
        child: LogoutDialog(isGuest: isGuest),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutFailure) {
          final message = switch (state.failure) {
            final AccountDeletionPartialFailure _ =>
              t.settings.deletePartialFailure,
            _ => t.settings.logoutFailed,
          };
          AppSnackBar.showError(context, state.failure.message ?? message);
        }
      },
      builder: (context, state) {
        final isLoading = state is LogoutLoading;

        return AlertDialog(
          title: Text(t.settings.logoutDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isGuest
                    ? t.settings.logoutGuestDialogBody
                    : t.settings.logoutDialogBody,
              ),
              if (isGuest) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  t.settings.deleteConfirmHint,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => context.pop(context),
              child: Text(t.core.actions.cancel),
            ),
            AppButton(
              label: isGuest
                  ? t.settings.logoutDeleteConfirm
                  : t.settings.logoutConfirm,
              isLoading: isLoading,
              onPressed: isLoading
                  ? null
                  : () => context.read<LogoutCubit>().logout(),
            ),
          ],
        );
      },
    );
  }
}

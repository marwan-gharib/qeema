import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';

class DeleteAssetConfirmationDialog extends StatelessWidget {
  const DeleteAssetConfirmationDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => const DeleteAssetConfirmationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t.assets.delete;
    final theme = context.theme;

    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        t.confirmTitle,
        style: theme.textTheme.titleMedium?.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        t.confirmBody,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(foregroundColor: colors.textSecondary),
          child: Text(context.t.core.actions.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.onPrimary,
          ),
          child: Text(context.t.core.actions.delete),
        ),
      ],
    );
  }
}

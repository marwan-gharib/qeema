import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';

class AppSnackBar {
  const AppSnackBar._();

  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).brightness == Brightness.light
              ? context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onError,
                )
              : null,
        ),
        backgroundColor: context.colorScheme.error,
      ),
    );
  }
}

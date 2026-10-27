import 'package:material_ui/material_ui.dart';

/// Shows a dialog through a single, themed entry point.
///
/// Use this instead of raw `showDialog` / `AlertDialog` in features (ANIM-2).
/// The dialog content (title, actions, etc.) is provided by the caller's
/// [builder]; localization and theming happen at the call site.
class AppDialog {
  const AppDialog._();

  /// Shows [builder] in a dialog and returns its result when popped.
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return showDialog<T>(context: context, builder: builder);
  }
}

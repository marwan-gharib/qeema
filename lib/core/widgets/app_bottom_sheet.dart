import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/theme/app_radius.dart';

/// Shows a modal bottom sheet through a single, themed entry point.
///
/// Use this instead of raw `showModalBottomSheet` in features (ANIM-2).
/// The sheet content is provided by the caller's [builder]; localization
/// and theming happen at the call site.
class AppBottomSheet {
  const AppBottomSheet._();

  /// Shows [builder] in a modal bottom sheet with a rounded top edge.
  ///
  /// Pass [backgroundColor] to override the sheet's background (defaults to
  /// the theme's sheet/surface color). The top radius defaults to
  /// `AppRadius.md`.
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
      ),
      builder: builder,
    );
  }
}

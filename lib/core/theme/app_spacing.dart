import 'package:qeema/core/responsive/responsive.dart';

/// Spacing scale in baseline design units (375×812).
///
/// Steps are plain doubles because every call site reads them through a
/// getter: [Responsive] is consulted lazily, so a value always reflects the
/// current screen size and the token itself can never be `const`.
class AppSpacing {
  const AppSpacing._();

  /// Micro gap (icon-to-label, badge internals).
  static double get xxxs => Responsive.adapt(2);

  /// Tight stack gap between closely related lines (title/value pairs).
  static double get tight => Responsive.adapt(6);

  static double get xxs => Responsive.adapt(4);

  static double get xs => Responsive.adapt(8);

  static double get sm => Responsive.adapt(12);

  static double get md => Responsive.adapt(16);

  static double get lg => Responsive.adapt(24);

  static double get xl => Responsive.adapt(32);

  static double get xxl => Responsive.adapt(48);
}

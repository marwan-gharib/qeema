import 'package:qeema/core/responsive/responsive.dart';

/// Corner radius scale in baseline design units (375×812).
class AppRadius {
  const AppRadius._();

  /// Badges, page indicators, tiny chips.
  static double get xxs => Responsive.radius(4);

  /// Small chips, skeleton blocks.
  static double get xs => Responsive.radius(8);

  /// Default surface: cards, buttons, inputs.
  static double get sm => Responsive.radius(12);

  /// Prominent surfaces: dialogs, sheets, themed cards.
  static double get md => Responsive.radius(16);

  /// Pill-like containers: tab bars, profile cards.
  static double get lg => Responsive.radius(20);

  /// Largest surface radius (profile header card).
  static double get xl => Responsive.radius(24);
}

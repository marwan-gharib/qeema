import 'package:qeema/core/responsive/responsive.dart';

/// Shared component dimensions in baseline design units (375×812).
///
/// Icon sizes are named by role, not by value, because the design uses a
/// distinct size for each role. The two unusual steps (13, 22) are kept
/// exactly as designed rather than folded into a neighbouring size.
class AppSizes {
  const AppSizes._();

  // Icons ---------------------------------------------------------------

  /// Inline trend/badge arrows.
  static double get iconMicro => Responsive.adapt(12);

  /// Status glyph beside small text (stale-data warning).
  static double get iconStatus => Responsive.adapt(13);

  /// Informational glyph / chevron sitting next to body text.
  static double get iconInline => Responsive.adapt(14);

  /// Compact rows: mini-card leading icon.
  static double get iconSmall => Responsive.adapt(16);

  /// Standard row leading icon.
  static double get iconMedium => Responsive.adapt(20);

  /// Settings and market-detail tiles.
  static double get iconTile => Responsive.adapt(22);

  /// List items and bottom-navigation icons (Material default).
  static double get iconStandard => Responsive.adapt(24);

  /// Asset-type tiles and picker glyphs.
  static double get iconLarge => Responsive.adapt(28);

  /// Asset badge and onboarding accent icons.
  static double get iconXl => Responsive.adapt(32);

  /// Hero glyph on detail screens and success pulse.
  static double get iconHero => Responsive.adapt(48);

  /// Onboarding illustration glyphs.
  static double get iconIllustration => Responsive.adapt(60);

  /// Empty-state and error-state glyphs.
  static double get iconState => Responsive.adapt(64);

  // Components ----------------------------------------------------------

  /// Accessibility floor for tappable surfaces. Deliberately NOT scaled:
  /// a touch target must never shrink below the Material guideline, and
  /// growing content pushes real button heights past this minimum anyway.
  static const double minTouchTarget = 48;

  /// Profile header avatar (square).
  static double get avatarLarge => Responsive.adapt(68);

  /// Inline progress indicator inside buttons.
  static double get loader => Responsive.adapt(20);

  /// Accent bar on insight cards.
  static double get accentBar => Responsive.width(4);

  /// Price sparkline canvas.
  static double get sparklineWidth => Responsive.width(40);

  static double get sparklineHeight => Responsive.height(44);
}

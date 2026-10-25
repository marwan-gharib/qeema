import 'package:flutter/widgets.dart';

/// Scaling policy shared by every [ResponsiveScaler] implementation.
///
/// Values that must NEVER be scaled, no matter the backend: durations,
/// opacity, flex factors, hairline border widths, elevation, line counts,
/// aspect ratios, percentages, and anything already derived from constraints
/// or MediaQuery (safe areas, keyboard insets, system padding).
abstract class ResponsiveScaler {
  const ResponsiveScaler();

  /// Effective scale factors are clamped to this range. A 768dp tablet would
  /// otherwise scale by 2.05x and a 1440dp desktop window by 3.84x, blowing
  /// the UI up; phones still get the ~15% of adjustment their varying sizes
  /// need (why: keep one sane level of zoom on every form factor).
  static const double minScaleFactor = 0.85;
  static const double maxScaleFactor = 1.30;

  /// The system text scale is capped here so very large accessibility
  /// settings cannot break fixed layouts. It is a cap, never a floor:
  /// scaling stays enabled and can still go down to the system minimum
  /// (why: one predictable ceiling instead of per-screen fixes).
  static const double maxTextScale = 1.3;

  /// Horizontal design dimension.
  double width(double value);

  /// Vertical design dimension.
  double height(double value);

  /// Corner radius — follows the smaller axis so radii never distort.
  double radius(double value);

  /// Font size — follows the smaller axis; Flutter still applies the system
  /// text scale on top of it.
  double font(double value);

  /// Squares and icons — min(width, height) so they stay square-ish.
  double adapt(double value);

  /// True once [configure] has supplied usable screen metrics. While false,
  /// every scale method must return its input unchanged (identity fallback).
  bool get isInitialized;

  /// Supplies the current screen metrics and the design baseline. Called by
  /// the scope whenever the screen size may have changed.
  void configure(MediaQueryData metrics, {required Size designSize});

  /// Called once at startup, before `runApp`.
  Future<void> ensureInitialized();
}

/// Pass-through implementation used before the real engine is bound and in
/// tests that never pump the responsive scope — returns inputs unchanged and
/// never throws.
class IdentityResponsiveScaler extends ResponsiveScaler {
  const IdentityResponsiveScaler();

  @override
  double width(double value) => value;

  @override
  double height(double value) => value;

  @override
  double radius(double value) => value;

  @override
  double font(double value) => value;

  @override
  double adapt(double value) => value;

  @override
  bool get isInitialized => false;

  @override
  void configure(MediaQueryData metrics, {required Size designSize}) {}

  @override
  Future<void> ensureInitialized() => Future<void>.value();
}

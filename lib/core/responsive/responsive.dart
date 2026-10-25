import 'package:flutter/widgets.dart';
import 'package:qeema/core/responsive/responsive_scaler.dart';
import 'package:qeema/core/responsive/screen_util_scaler.dart'
    show createResponsiveScaler;

/// The app-wide facade for responsive values. Feature, widget, theme and
/// helper code talks only to this class — never to a specific scaling engine.
///
/// The single binding lives here (`_scaler`): swapping or removing the
/// backend means editing `screen_util_scaler.dart` (and pubspec), nothing else.
///
/// Before the responsive scope configures the engine — in unit tests and any
/// widget test that does not pump [ResponsiveScope] — the scaler behaves as an
/// identity transform: it returns inputs unchanged and never throws.
final class Responsive {
  const Responsive._();

  /// The design baseline the whole UI is drawn against, in logical pixels
  /// (width x height, portrait phone).
  static const Size designSize = Size(375, 812);

  static ResponsiveScaler _scaler = createResponsiveScaler();

  /// Binds the app's scaling engine. Called by [ResponsiveScope] on mount.
  static void bindDefault() => _scaler = createResponsiveScaler();

  /// Binds the identity scaler. Called by [ResponsiveScope] on dispose so
  /// tests outside the scope keep the pre-scale behaviour.
  static void unbind() => _scaler = const IdentityResponsiveScaler();

  /// Binds an arbitrary implementation (fakes in tests, a future backend).
  static void bind(ResponsiveScaler scaler) => _scaler = scaler;

  /// Whether the bound engine has real screen metrics yet.
  static bool get isInitialized => _scaler.isInitialized;

  static double width(double value) => _scaler.width(value);

  static double height(double value) => _scaler.height(value);

  static double radius(double value) => _scaler.radius(value);

  static double font(double value) => _scaler.font(value);

  static double adapt(double value) => _scaler.adapt(value);

  /// Forwards current screen metrics to the bound engine.
  static void configure(MediaQueryData metrics, {required Size designSize}) =>
      _scaler.configure(metrics, designSize: designSize);

  /// Waits for the engine to be usable — called once from `main()` before
  /// `runApp`.
  static Future<void> ensureInitialized() => _scaler.ensureInitialized();
}

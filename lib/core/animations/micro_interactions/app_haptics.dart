import 'package:flutter/services.dart';

/// Haptic feedback through a single, central entry point.
///
/// Use this instead of raw `HapticFeedback` in features (ANIM-2). All
/// haptic calls go through this class so the implementation owns platform
/// differences and error handling (ARCH-5).
class AppHaptics {
  const AppHaptics._();

  /// A light impact haptic feedback.
  static void light() => HapticFeedback.lightImpact();

  /// A medium impact haptic feedback.
  static void medium() => HapticFeedback.mediumImpact();

  /// A heavy impact haptic feedback.
  static void heavy() => HapticFeedback.heavyImpact();

  /// A selection changed haptic feedback.
  static void selection() => HapticFeedback.selectionClick();
}

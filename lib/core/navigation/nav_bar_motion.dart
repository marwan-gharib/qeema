import 'package:flutter/animation.dart';
import 'package:qeema/core/animations/app_motion.dart';

class NavBarMotion {
  const NavBarMotion._();

  /// Time for the selected badge to travel between tabs.
  static const Duration badgeTravel = AppMotion.normal;

  /// Bouncy overshoot so the badge "lifts and settles" on arrival.
  static const Curve badgeCurve = AppMotion.emphasized;

  /// Time for a tab's icon/label to fade out once its badge takes over.
  static const Duration labelFade = AppMotion.normal;
}

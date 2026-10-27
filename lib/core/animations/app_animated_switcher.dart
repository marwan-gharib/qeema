import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/app_motion.dart';

/// A switcher that animates between children using core motion tokens.
///
/// Honours `MediaQuery.disableAnimations`: when reduced motion is on, the
/// child is shown without any transition. Use this instead of raw
/// `AnimatedSwitcher` in features (ANIM-2).
class AppAnimatedSwitcher extends StatelessWidget {
  const AppAnimatedSwitcher({
    super.key,
    required this.child,
    this.duration = AppMotion.normal,
    this.switchInCurve = AppMotion.entrance,
    this.switchOutCurve = AppMotion.exit,
  });

  final Widget child;
  final Duration duration;
  final Curve switchInCurve;
  final Curve switchOutCurve;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return child;
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: switchInCurve,
      switchOutCurve: switchOutCurve,
      child: child,
    );
  }
}

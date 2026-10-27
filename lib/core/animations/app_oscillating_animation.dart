import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/app_motion.dart';

/// Drives a continuous back-and-forth oscillation (0 → 1 → 0) using a
/// repeating `AnimationController` managed entirely in core.
///
/// Use for breath, pulse, or any oscillating visual effect. Honours
/// `MediaQuery.disableAnimations` (renders at the mid value when reduced
/// motion is on). This keeps `AnimationController` out of features (ANIM-2).
class AppOscillatingAnimation extends StatefulWidget {
  const AppOscillatingAnimation({
    super.key,
    required this.builder,
    this.duration = AppMotion.heroSlow,
  });

  final Widget Function(BuildContext context, double value) builder;
  final Duration duration;

  @override
  State<AppOscillatingAnimation> createState() =>
      _AppOscillatingAnimationState();
}

class _AppOscillatingAnimationState extends State<AppOscillatingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: AppMotion.standard,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return widget.builder(context, 0.5);
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => widget.builder(context, _animation.value),
    );
  }
}

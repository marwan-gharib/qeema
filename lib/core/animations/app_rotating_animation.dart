import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/app_motion.dart';

/// Drives a continuous rotation (0 → 1 turn) using a repeating
/// `AnimationController` managed entirely in core.
///
/// The builder receives a `double` in `0..1` representing turns; multiply by
/// `2 * pi` for radians. Honours `MediaQuery.disableAnimations` (renders
/// statically at angle 0 when reduced motion is on). Keeps
/// `AnimationController` out of features (ANIM-2).
class AppRotatingAnimation extends StatefulWidget {
  const AppRotatingAnimation({
    super.key,
    required this.builder,
    this.duration = AppMotion.heroSlow,
  });

  final Widget Function(BuildContext context, double turns) builder;
  final Duration duration;

  @override
  State<AppRotatingAnimation> createState() => _AppRotatingAnimationState();
}

class _AppRotatingAnimationState extends State<AppRotatingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
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
      return widget.builder(context, 0.0);
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => widget.builder(context, _animation.value),
    );
  }
}

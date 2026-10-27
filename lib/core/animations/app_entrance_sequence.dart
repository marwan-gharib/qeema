import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/app_motion.dart';

/// Computed values from an `AppEntranceSequence`. All values are in `0..1`
/// unless otherwise noted.
///
/// - `phase1`: 0 → 1 over the first 50% of the duration (for leading
///   elements such as a logo).
/// - `phase2`: 0 → 1 over the last 40% (starts at 60%, for trailing
///   elements such as body text).
/// - `fade`: 0 → 1 over the full duration.
/// - `scale`: 0 → 1 over the full duration.
/// - `slideUp`: `Offset(0, 0.5)` → `Offset.zero` over the full duration.
class AppEntranceValues {
  const AppEntranceValues({
    required this.phase1,
    required this.phase2,
    required this.fade,
    required this.scale,
    required this.slideUp,
  });

  final double phase1;
  final double phase2;
  final double fade;
  final double scale;
  final Offset slideUp;
}

/// Plays a one-shot entrance sequence on mount, with staggered phases for
/// leading and trailing elements. The controller runs `forward()` once and
/// is disposed with the widget.
///
/// Use this instead of a raw `AnimationController` + `Tween` setup in
/// features (ANIM-2). All animation math lives in core.
class AppEntranceSequence extends StatefulWidget {
  const AppEntranceSequence({
    super.key,
    required this.builder,
    this.duration = AppMotion.hero,
  });

  final Widget Function(BuildContext context, AppEntranceValues values) builder;
  final Duration duration;

  @override
  State<AppEntranceSequence> createState() => _AppEntranceSequenceState();
}

class _AppEntranceSequenceState extends State<AppEntranceSequence>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _phase1;
  late final Animation<double> _phase2;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();

    _phase1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: AppMotion.emphasized),
      ),
    );
    _phase2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: AppMotion.entrance),
      ),
    );
    _fade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: AppMotion.entrance));
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppMotion.emphasized),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: AppMotion.entrance));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return widget.builder(
        context,
        const AppEntranceValues(
          phase1: 1.0,
          phase2: 1.0,
          fade: 1.0,
          scale: 1.0,
          slideUp: Offset.zero,
        ),
      );
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => widget.builder(
        context,
        AppEntranceValues(
          phase1: _phase1.value,
          phase2: _phase2.value,
          fade: _fade.value,
          scale: _scale.value,
          slideUp: _slideUp.value,
        ),
      ),
    );
  }
}

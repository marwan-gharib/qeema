import 'package:flutter/material.dart';

import '../app_motion.dart';

/// Scales [child] down slightly on press-down and back on release/cancel.
///
/// Provides consistent tactile feedback for buttons, cards, and tiles.
/// When [MediaQuery.disableAnimations] is true, passes through with no scale.
///
/// Example:
/// ```dart
/// TapScale(
///   onTap: () => addAsset(),
///   child: MyCard(...),
/// )
/// ```
class TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;

  const TapScale({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.96,
  });

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    if (MediaQuery.of(context).disableAnimations) return;

    _controller = AnimationController(vsync: this, duration: AppMotion.fast);
    _animation = Tween(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(parent: _controller!, curve: AppMotion.standard));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller?.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller?.reverse();
  }

  void _onTapCancel() {
    _controller?.reverse();
  }

  @override
  Widget build(BuildContext context) {
    var child = widget.child;
    if (_animation != null) {
      child = GestureDetector(
        onTap: widget.onTap,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: ScaleTransition(scale: _animation!, child: child),
      );
    }
    return child;
  }
}

import 'package:flutter/material.dart';

import '../../extensions/build_context_extensions.dart';
import '../app_motion.dart';

/// A celebratory scale-pulse + checkmark fade-in, triggered once when
/// [triggered] becomes true.
///
/// When [MediaQuery.disableAnimations] is true, shows the checkmark
/// immediately with no animation.
class SuccessPulse extends StatefulWidget {
  final bool triggered;
  final Widget child;
  final Widget? checkmark;

  const SuccessPulse({
    super.key,
    required this.triggered,
    required this.child,
    this.checkmark,
  });

  @override
  State<SuccessPulse> createState() => _SuccessPulseState();
}

class _SuccessPulseState extends State<SuccessPulse>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _pulse;
  Animation<double>? _checkOpacity;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeStart();
  }

  @override
  void didUpdateWidget(SuccessPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.triggered && widget.triggered && _controller == null) {
      _maybeStart();
    }
  }

  void _maybeStart() {
    if (!widget.triggered) return;
    if (_controller != null) return;
    if (MediaQuery.of(context).disableAnimations) return;

    _controller = AnimationController(vsync: this, duration: AppMotion.slow);
    _pulse = Tween(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller!, curve: AppMotion.emphasized),
    );
    _checkOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );
    _controller!.forward().then((_) {
      if (mounted) _controller?.reverse();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return widget.triggered ? _buildContent(context) : widget.child;
    }

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return Transform.scale(scale: _pulse?.value ?? 1.0, child: child);
      },
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (!widget.triggered) return widget.child;

    final check =
        widget.checkmark ??
        Icon(Icons.check_circle, color: context.colors.secondary, size: 48);

    if (_checkOpacity == null) {
      return Stack(
        alignment: Alignment.center,
        children: [widget.child, check],
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        FadeTransition(opacity: _checkOpacity!, child: check),
      ],
    );
  }
}

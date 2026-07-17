import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../app_motion.dart';

/// Animates counting from the previous [value] to the new one whenever
/// [value] changes, formatting through [formatter] on each frame.
///
/// The internal tween works on a [double] for the visual interpolation;
/// the actual [Decimal] is never replaced — this widget is presentation-only.
/// When [MediaQuery.disableAnimations] is true, renders the final value
/// directly without animation.
class AnimatedCounter extends StatefulWidget {
  final Decimal value;
  final TextStyle? style;
  final String Function(Decimal) formatter;

  const AnimatedCounter({
    super.key,
    required this.value,
    required this.formatter,
    this.style,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> {
  late double _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value.toDouble();
  }

  @override
  void didUpdateWidget(AnimatedCounter old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _previousValue = old.value.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = MediaQuery.of(context).disableAnimations;
    final target = widget.value.toDouble();

    if (disabled) {
      return Text(widget.formatter(widget.value), style: widget.style);
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: _previousValue, end: target),
      duration: AppMotion.slow,
      curve: AppMotion.entrance,
      builder: (context, tweenValue, _) {
        return Text(
          widget.formatter(Decimal.parse(tweenValue.toStringAsFixed(4))),
          style: widget.style,
        );
      },
    );
  }
}

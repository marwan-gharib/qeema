import 'package:flutter/material.dart';

import 'app_motion.dart';
import 'entry_animation_type.dart';

/// Wraps [child] in an entrance animation chosen via [type].
///
/// Checks [MediaQuery.disableAnimations] and, when true, renders [child]
/// directly with no [AnimationController] created.
///
/// Example:
/// ```dart
/// AppAnimatedEntry(
///   type: EntryAnimationType.scaleIn,
///   child: SummaryCard(...),
/// )
/// ```
class AppAnimatedEntry extends StatefulWidget {
  final Widget child;
  final EntryAnimationType type;
  final Duration duration;
  final Duration delay;
  final Curve? curve;

  const AppAnimatedEntry({
    super.key,
    required this.child,
    this.type = EntryAnimationType.fadeSlideUp,
    this.duration = AppMotion.normal,
    this.delay = Duration.zero,
    this.curve,
  });

  @override
  State<AppAnimatedEntry> createState() => _AppAnimatedEntryState();
}

class _AppAnimatedEntryState extends State<AppAnimatedEntry>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _opacity;
  Animation<Offset>? _slide;
  Animation<double>? _scale;
  var _disabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == EntryAnimationType.none) {
      _disabled = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_disabled) return;
    if (_controller != null) return;

    if (MediaQuery.of(context).disableAnimations) {
      _disabled = true;
      return;
    }

    _controller = AnimationController(vsync: this, duration: widget.duration);

    final curve = widget.curve ?? _defaultCurve(widget.type);
    final curved = CurvedAnimation(parent: _controller!, curve: curve);

    switch (widget.type) {
      case EntryAnimationType.fadeIn:
        _opacity = Tween(begin: 0.0, end: 1.0).animate(curved);
      case EntryAnimationType.fadeSlideUp:
        _opacity = Tween(begin: 0.0, end: 1.0).animate(curved);
        _slide = Tween(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(curved);
      case EntryAnimationType.fadeSlideDown:
        _opacity = Tween(begin: 0.0, end: 1.0).animate(curved);
        _slide = Tween(
          begin: const Offset(0, -0.08),
          end: Offset.zero,
        ).animate(curved);
      case EntryAnimationType.fadeSlideRight:
        _opacity = Tween(begin: 0.0, end: 1.0).animate(curved);
        _slide = Tween(
          begin: const Offset(-0.08, 0),
          end: Offset.zero,
        ).animate(curved);
      case EntryAnimationType.scaleIn:
        _opacity = Tween(begin: 0.0, end: 1.0).animate(curved);
        _scale = Tween(begin: 0.85, end: 1.0).animate(curved);
      case EntryAnimationType.popIn:
        _opacity = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller!, curve: AppMotion.entrance),
        );
        _scale = Tween(begin: 0.7, end: 1.0).animate(curved);
      case EntryAnimationType.none:
        break;
    }

    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller!.forward();
      });
    } else {
      _controller!.forward();
    }
  }

  Curve _defaultCurve(EntryAnimationType type) {
    return switch (type) {
      EntryAnimationType.popIn => AppMotion.emphasized,
      _ => AppMotion.entrance,
    };
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_disabled || _controller == null) return widget.child;

    var child = widget.child;
    if (_opacity != null) {
      child = FadeTransition(opacity: _opacity!, child: child);
    }
    if (_slide != null) {
      child = SlideTransition(position: _slide!, child: child);
    }
    if (_scale != null) {
      child = ScaleTransition(scale: _scale!, child: child);
    }
    return child;
  }
}

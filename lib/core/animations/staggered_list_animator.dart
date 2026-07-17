import 'package:flutter/material.dart';

import 'app_animated_entry.dart';
import 'app_motion.dart';
import 'entry_animation_type.dart';

/// Wraps each [children] in an [AppAnimatedEntry] with an incremental
/// [AppMotion.staggerStep] delay, producing a cascade effect.
///
/// Total stagger delay is capped at [AppMotion.maxStaggerTotal] so a
/// long list doesn't take several seconds to finish appearing.
///
/// Example:
/// ```dart
/// StaggeredListAnimator(
///   type: EntryAnimationType.fadeSlideUp,
///   children: myWidgetList,
/// )
/// ```
class StaggeredListAnimator extends StatelessWidget {
  final List<Widget> children;
  final EntryAnimationType type;

  const StaggeredListAnimator({
    super.key,
    required this.children,
    this.type = EntryAnimationType.fadeSlideUp,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++)
          AppAnimatedEntry(
            type: type,
            delay: Duration(
              milliseconds: (i * AppMotion.staggerStep.inMilliseconds).clamp(
                0,
                AppMotion.maxStaggerTotal.inMilliseconds,
              ),
            ),
            child: children[i],
          ),
      ],
    );
  }
}

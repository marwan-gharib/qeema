import 'package:flutter/widgets.dart';

/// Caps content width on large screens (tablets, landscape) and centers it,
/// so text lines and cards keep a readable measure instead of stretching to
/// the viewport edge. The cap is a fixed logical-dp reading measure and is
/// deliberately not scaled: it bounds layout width, not rendered size.
class AppContentBox extends StatelessWidget {
  const AppContentBox({super.key, required this.child});

  /// 672 minus a typical 2×16 body padding leaves a 640dp reading measure.
  /// Deliberately above 640: narrower content re-wraps long unbreakable
  /// strings (the home erosion caption measures 620dp) and shifts below-fold
  /// sections by a line, breaking their rendering assumptions.
  static const double maxWidth = 672;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

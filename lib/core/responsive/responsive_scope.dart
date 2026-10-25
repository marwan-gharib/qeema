import 'package:flutter/widgets.dart';

import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/responsive/responsive_scaler.dart';

/// Wraps the app root. It:
///
///  * binds the scaling engine on mount and restores the identity scaler on
///    dispose (so tests that never pump it keep the pre-scale behaviour),
///  * keeps the engine configured with the current screen metrics and the
///    design baseline,
///  * rebuilds the subtree when the screen size changes (rotation, window
///    resize, split screen, foldables) so every scaled value is recomputed,
///  * clamps the system text scale once for the whole app.
///
/// [child] should be cheap to hand around (AppRoot passes a const child):
/// ordinary MediaQuery changes — the keyboard, for instance — rebuild only
/// this widget, never the app below it.
class ResponsiveScope extends StatefulWidget {
  const ResponsiveScope({
    super.key,
    required this.child,
    this.designSize = Responsive.designSize,
  });

  final Widget child;
  final Size designSize;

  @override
  State<ResponsiveScope> createState() => _ResponsiveScopeState();
}

class _ResponsiveScopeState extends State<ResponsiveScope> {
  Size? _lastSize;

  @override
  void initState() {
    super.initState();
    Responsive.bindDefault();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final metrics = MediaQuery.of(context);
    Responsive.configure(metrics, designSize: widget.designSize);
    if (_lastSize != metrics.size) {
      _lastSize = metrics.size;
      // Scaled values are baked in at build time, so a size change has to
      // dirty the subtree explicitly — const/unbuilt subtrees would otherwise
      // keep their old sizes after a rotation or resize.
      (context as Element).visitChildren(_markDirty);
    }
  }

  @override
  void dispose() {
    Responsive.unbind();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = MediaQuery.of(context);
    return MediaQuery(
      data: metrics.copyWith(
        textScaler: metrics.textScaler.clamp(
          maxScaleFactor: ResponsiveScaler.maxTextScale,
        ),
      ),
      child: widget.child,
    );
  }

  void _markDirty(Element element) {
    element.markNeedsBuild();
    element.visitChildren(_markDirty);
  }
}

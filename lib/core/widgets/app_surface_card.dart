import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/micro_interactions/tap_scale.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';

/// The shared surface-alt card shell: rounded background + padding, with an
/// optional tap handler. Each card widget keeps its own inner layout — only
/// the outer shell is shared.
class AppSurfaceCard extends StatelessWidget {
  const AppSurfaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.borderRadius = 12,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );

    if (onTap == null) return card;
    return TapScale(onTap: onTap, child: card);
  }
}

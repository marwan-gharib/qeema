import 'package:flutter/material.dart';

import '../../extensions/build_context_extensions.dart';
import '../app_motion.dart';

/// A themed shimmer placeholder — an animated gradient sweep over a rounded
/// rectangle. Gradient colors use [context.colors] (surface / surfaceAlt / divider)
/// so it looks correct in light and dark themes.
///
/// When [MediaQuery.disableAnimations] is true, renders a static filled box.
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _shift;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    if (MediaQuery.of(context).disableAnimations) return;

    _controller = AnimationController(vsync: this, duration: AppMotion.slow)
      ..repeat();
    _shift = Tween(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_shift == null) {
      return _buildSolid(context);
    }

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, _) => _buildShimmer(context),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment(-1.0 + _shift!.value, 0),
          end: Alignment(2.0 + _shift!.value, 0),
          colors: [
            context.colors.surfaceAlt,
            context.colors.surface,
            context.colors.divider,
            context.colors.surface,
            context.colors.surfaceAlt,
          ],
          stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
        ).createShader(bounds);
      },
      child: _buildSolid(context),
    );
  }

  Widget _buildSolid(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: context.colors.surfaceAlt,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
    );
  }
}

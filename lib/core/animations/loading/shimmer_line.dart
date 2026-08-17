import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';

/// A text-line-shaped shimmer placeholder — the smallest repeated skeleton
/// primitive, used inside feature skeletons to stand in for a single label
/// or caption line.
class ShimmerLine extends StatelessWidget {
  const ShimmerLine({
    super.key,
    this.width = double.infinity,
    this.height = 14,
    this.borderRadius = 4,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(width: width, height: height, borderRadius: borderRadius);
  }
}

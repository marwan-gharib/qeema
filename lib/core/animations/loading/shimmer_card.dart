import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/loading/shimmer_box.dart';

/// A rounded-rectangle shimmer block — the second smallest repeated skeleton
/// primitive, used inside feature skeletons to stand in for a card, field,
/// or chart area. Height stays a parameter because each screen's block
/// dimensions mirror its real UI.
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.width = double.infinity,
    this.height = 140,
    this.borderRadius = 12,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(width: width, height: height, borderRadius: borderRadius);
  }
}

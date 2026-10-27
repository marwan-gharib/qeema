import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';

const double _glowSize = 120.0;
const double _pulseMaxSpread = 60.0;
const double _pulseMaxBlur = 30.0;

class LogoPulseGlow extends StatelessWidget {
  const LogoPulseGlow({super.key, required this.pulseValue});
  final double pulseValue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final pulseAlpha = 1.0 - pulseValue;
    return Container(
      width: _glowSize,
      height: _glowSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colors.secondaryVariant.withValues(alpha: pulseAlpha),
            spreadRadius: pulseValue * _pulseMaxSpread,
            blurRadius: pulseValue * _pulseMaxBlur,
          ),
        ],
      ),
    );
  }
}

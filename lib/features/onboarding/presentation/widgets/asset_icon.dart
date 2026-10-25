import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/theme/app_sizes.dart';
import 'package:qeema/core/theme/app_spacing.dart';

class AssetIcon extends StatelessWidget {
  const AssetIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSizes.iconState,
          height: AppSizes.iconState,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.15),
          ),
          child: Icon(icon, size: AppSizes.iconXl, color: color),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

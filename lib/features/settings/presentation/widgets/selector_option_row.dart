import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_sizes.dart';
import 'package:qeema/core/theme/app_spacing.dart';

class SelectorOptionRow extends StatelessWidget {
  const SelectorOptionRow({
    super.key,
    required this.label,
    required this.isSelected,
  });

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? colors.primary.withValues(alpha: 0.12)
            : colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: isSelected
            ? Border.all(color: colors.primary)
            : Border.all(color: colors.divider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodyLarge!.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ),
          if (isSelected)
            Icon(Icons.check, size: AppSizes.iconMedium, color: colors.primary),
        ],
      ),
    );
  }
}

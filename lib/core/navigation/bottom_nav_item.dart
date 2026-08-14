import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/micro_interactions/tap_scale.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/navigation/bottom_nav_item_config.dart';
import 'package:qeema/core/navigation/nav_bar_motion.dart';
import 'package:qeema/core/theme/app_spacing.dart';

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.config,
    required this.isSelected,
    required this.onTap,
  });

  final BottomNavItemConfig config;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final fadeDuration = disableAnimations
        ? Duration.zero
        : NavBarMotion.labelFade;

    return TapScale(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            duration: fadeDuration,
            opacity: isSelected ? 0 : 1,
            child: Icon(config.icon, size: 24, color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xxs),
          AnimatedOpacity(
            duration: fadeDuration,
            opacity: isSelected ? 0 : 1,
            child: Text(
              config.labelBuilder(context),
              style: context.textTheme.labelSmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

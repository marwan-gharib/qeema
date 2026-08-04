import 'package:flutter/material.dart';
import 'package:qeema/core/animations/micro_interactions/tap_scale.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/navigation/bottom_nav_item.dart';
import 'package:qeema/core/navigation/bottom_nav_item_config.dart';
import 'package:qeema/core/navigation/nav_bar_motion.dart';
import 'package:qeema/core/theme/app_spacing.dart';

/// Bar height — starting value to measure on a real device; the bar must
/// read as a floating dock, clearly separated from the screen edges.
final double _barHeight = 64;

final double _barRadius = _barHeight / 2;
final double _badgeSize = AppSpacing.xxl.toDouble();
final double _badgeLift = _badgeSize / 2;
final double _iconSize = _badgeSize / 2;

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final travelDuration = disableAnimations
        ? Duration.zero
        : NavBarMotion.badgeTravel;
    final items = BottomNavItemConfig.items;
    final selectedConfig = items[currentIndex];

    return SafeArea(
      minimum: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        height: _barHeight,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(_barRadius),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / items.length;
            final badgeStart =
                itemWidth * (currentIndex + 0.5) - _badgeSize / 2;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  children: [
                    for (final entry in items.asMap().entries)
                      Expanded(
                        child: BottomNavItem(
                          config: entry.value,
                          isSelected: entry.key == currentIndex,
                          onTap: () => onTap(entry.key),
                        ),
                      ),
                  ],
                ),
                AnimatedPositionedDirectional(
                  duration: travelDuration,
                  curve: NavBarMotion.badgeCurve,
                  start: badgeStart,
                  top: -_badgeLift / 2,
                  child: TapScale(
                    onTap: () => onTap(currentIndex),
                    child: Container(
                      width: _badgeSize,
                      height: _badgeSize,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: travelDuration,
                        child: Icon(
                          selectedConfig.selectedIcon,
                          key: ValueKey(selectedConfig.routePath),
                          size: _iconSize,
                          color: colors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

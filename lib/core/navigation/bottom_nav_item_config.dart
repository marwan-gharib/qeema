import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_paths.dart';

class BottomNavItemConfig {
  const BottomNavItemConfig({
    required this.icon,
    required this.selectedIcon,
    required this.labelBuilder,
    required this.routePath,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String Function(BuildContext) labelBuilder;
  final String routePath;

  /// Order and count must stay in sync with the branches of
  /// `AppRouter.shellRoute` in `app_router.dart` — index i here is
  /// branch i there. Tabs are added here and as branches together.
  static List<BottomNavItemConfig> get items => [
    BottomNavItemConfig(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      labelBuilder: (context) => context.t.nav.home,
      routePath: RoutePaths.home,
    ),
    BottomNavItemConfig(
      icon: Icons.pie_chart_outline,
      selectedIcon: Icons.pie_chart,
      labelBuilder: (context) => context.t.nav.assets,
      routePath: RoutePaths.assets,
    ),
  ];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_cubit.dart';

class AssetTypeTabBar extends StatelessWidget {
  const AssetTypeTabBar({super.key, required this.activeFilter});

  final AssetType? activeFilter;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final t = context.t.assets;

    final tabs = <_TabItem>[
      _TabItem(label: t.filter.all, type: null),
      _TabItem(label: t.list.tabEgp, type: AssetType.egpCash),
      _TabItem(label: t.list.tabUsd, type: AssetType.usdCash),
      _TabItem(label: t.list.tabGold21, type: AssetType.gold21),
      _TabItem(label: t.list.tabGold24, type: AssetType.gold24),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: tabs.map((tab) {
          final isActive = activeFilter == tab.type;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: GestureDetector(
              onTap: () =>
                  context.read<AssetsListCubit>().changeFilter(tab.type),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive ? colors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tab.label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isActive ? colors.onPrimary : colors.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.label, this.type});

  final String label;
  final AssetType? type;
}

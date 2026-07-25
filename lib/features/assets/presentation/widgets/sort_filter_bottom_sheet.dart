import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_cubit.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_state.dart';

class SortFilterBottomSheet extends StatelessWidget {
  const SortFilterBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(
        context,
      ).extension<AppColorsExtension>()!.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const SortFilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final t = context.t.assets.list;
    final cubit = context.read<AssetsListCubit>();
    final state = cubit.state;
    final currentSort = state is AssetsListLoaded
        ? state.sortBy
        : AssetsSortBy.dateNewest;

    final sortOptions = <_SortOption>[
      _SortOption(t.sortDateNewest, AssetsSortBy.dateNewest),
      _SortOption(t.sortDateOldest, AssetsSortBy.dateOldest),
      _SortOption(t.sortValueHighest, AssetsSortBy.valueHighest),
      _SortOption(t.sortValueLowest, AssetsSortBy.valueLowest),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.sortFilter,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...sortOptions.map(
              (option) => ListTile(
                title: Text(
                  option.label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: colors.textPrimary),
                ),
                leading: Icon(
                  option.value == currentSort
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: option.value == currentSort
                      ? colors.primary
                      : colors.textSecondary,
                ),
                onTap: () {
                  cubit.changeSort(option.value);
                  Navigator.of(context).pop();
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortOption {
  const _SortOption(this.label, this.value);

  final String label;
  final AssetsSortBy value;
}

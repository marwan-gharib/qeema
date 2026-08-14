import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_cubit.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_state.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_list_item.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_type_tab_bar.dart';
import 'package:qeema/features/assets/presentation/widgets/assets_empty_state.dart';
import 'package:qeema/features/assets/presentation/widgets/assets_error_state.dart';
import 'package:qeema/features/assets/presentation/widgets/assets_loading_skeleton.dart';
import 'package:qeema/features/assets/presentation/widgets/sort_filter_bottom_sheet.dart';

class AssetsListScreen extends StatelessWidget {
  const AssetsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final t = context.t.assets.list;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(t.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            onPressed: () => SortFilterBottomSheet.show(context),
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<AssetsListCubit, AssetsListState>(
            builder: (context, state) {
              if (state is AssetsListLoaded) {
                return AssetTypeTabBar(activeFilter: state.activeFilter);
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: BlocBuilder<AssetsListCubit, AssetsListState>(
              builder: (context, state) {
                return switch (state) {
                  AssetsListInitial() ||
                  AssetsListLoading() => const AssetsLoadingSkeleton(),
                  AssetsListError(message: final msg) => AssetsErrorState(
                    message: msg,
                  ),
                  AssetsListLoaded(:final visibleAssets, :final activeFilter) =>
                    visibleAssets.isEmpty
                        ? AssetsEmptyState(isFiltered: activeFilter != null)
                        : RefreshIndicator(
                            onRefresh: context.read<AssetsListCubit>().refresh,
                            child: ListView.separated(
                              padding: EdgeInsets.only(
                                bottom:
                                    80 + MediaQuery.paddingOf(context).bottom,
                              ),
                              itemCount: visibleAssets.length,
                              separatorBuilder: (_, _) =>
                                  Divider(height: 1, color: colors.divider),
                              itemBuilder: (context, index) =>
                                  AssetListItem(asset: visibleAssets[index]),
                            ),
                          ),
                };
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        onPressed: () => context.pushNamed(RouteNames.addAsset),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

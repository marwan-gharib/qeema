import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/widgets/app_empty_state.dart';
import 'package:qeema/core/widgets/app_error_state.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/presentation/blocs/assets_bloc/assets_bloc.dart';
import 'package:qeema/features/assets/presentation/blocs/assets_bloc/assets_event.dart';
import 'package:qeema/features/assets/presentation/blocs/assets_bloc/assets_state.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_filter_tabs.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_list_item.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_sort_filter_sheet.dart';

class AssetsListScreen extends StatefulWidget {
  const AssetsListScreen({super.key});

  @override
  State<AssetsListScreen> createState() => _AssetsListScreenState();
}

class _AssetsListScreenState extends State<AssetsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AssetsBloc>().add(const AssetsSubscriptionRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.assets.list.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortSheet(context),
          ),
        ],
      ),
      body: BlocBuilder<AssetsBloc, AssetsState>(
        builder: (context, state) {
          return switch (state) {
            AssetsLoading() => const Center(child: CircularProgressIndicator()),
            AssetsLoadFailure(failure: final f) => AppErrorState(
              message: f.message,
            ),
            AssetsLoadSuccess(
              :final assets,
              :final assetTypes,
              :final filterType,
              :final sortBy,
            ) =>
              _buildContent(context, assets, assetTypes, filterType, sortBy),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAdd(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<AssetEntity> allAssets,
    List<AssetTypeEntity> assetTypes,
    String? filterType,
    String sortBy,
  ) {
    var filtered = allAssets;
    if (filterType != null) {
      filtered = filtered.where((a) => a.assetTypeCode == filterType).toList();
    }
    switch (sortBy) {
      case 'value':
        filtered = List.from(filtered)
          ..sort((a, b) => b.priceAtEntry.compareTo(a.priceAtEntry));
      case 'type':
        filtered = List.from(filtered)
          ..sort((a, b) => a.assetTypeCode.compareTo(b.assetTypeCode));
      default:
        filtered = List.from(filtered)
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }

    return Column(
      children: [
        AssetFilterTabs(
          assetTypes: assetTypes,
          selectedCode: filterType,
          onSelected: (code) =>
              context.read<AssetsBloc>().add(AssetFilterChanged(code)),
        ),
        const SizedBox(height: 8),
        if (filtered.isEmpty)
          Expanded(
            child: AppEmptyState(
              icon: allAssets.isEmpty
                  ? Icons.account_balance_wallet_outlined
                  : Icons.filter_list_off,
              title: allAssets.isEmpty
                  ? context.t.assets.list.emptyNoAssets
                  : context.t.assets.list.emptyNoFiltered,
              subtitle: allAssets.isEmpty
                  ? context.t.assets.list.emptyNoAssetsSubtitle
                  : context.t.assets.list.emptyNoFilteredSubtitle,
              actionLabel: allAssets.isEmpty
                  ? context.t.assets.list.addFirst
                  : null,
              onAction: allAssets.isEmpty
                  ? () => _navigateToAdd(context)
                  : null,
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final asset = filtered[index];
                return AssetListItem(
                  asset: asset,
                  onTap: () => _navigateToDetail(context, asset.id),
                );
              },
            ),
          ),
      ],
    );
  }

  void _showSortSheet(BuildContext context) {
    final currentState = context.read<AssetsBloc>().state;
    if (currentState is AssetsLoadSuccess) {
      AssetSortFilterSheet.show(context, currentState.sortBy).then((sortBy) {
        if (sortBy != null && context.mounted) {
          context.read<AssetsBloc>().add(AssetSortChanged(sortBy));
        }
      });
    }
  }

  void _navigateToAdd(BuildContext context) {
    context.pushNamed(RouteNames.addAsset);
  }

  void _navigateToDetail(BuildContext context, String assetId) {
    context.pushNamed(
      RouteNames.assetDetail,
      pathParameters: {'assetId': assetId},
    );
  }
}

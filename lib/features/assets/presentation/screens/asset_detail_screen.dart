import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/widgets/app_empty_state.dart';
import 'package:qeema/core/widgets/app_error_state.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/presentation/cubits/asset_detail_cubit/asset_detail_cubit.dart';
import 'package:qeema/features/assets/presentation/cubits/asset_detail_cubit/asset_detail_state.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_detail_content.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_detail_skeleton.dart';

class AssetDetailScreen extends StatelessWidget {
  const AssetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return BlocConsumer<AssetDetailCubit, AssetDetailState>(
      listener: (context, state) {
        if (state is AssetDetailNotFound) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(t.assets.detail.notFoundBody)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: state is AssetDetailLoaded
                ? Text(_typeLabel(state.asset.assetType))
                : null,
          ),
          body: AnimatedSwitcher(
            duration: MediaQuery.of(context).disableAnimations
                ? Duration.zero
                : AppMotion.normal,
            child: switch (state) {
              AssetDetailInitial() ||
              AssetDetailLoading() => const AssetDetailSkeleton(),
              AssetDetailError(:final failure) => AppErrorState(
                message: failure.message,
                onRetry: () => context.read<AssetDetailCubit>().refresh(),
              ),
              AssetDetailNotFound() => AppEmptyState(
                icon: Icons.search_off_rounded,
                title: t.assets.detail.notFoundTitle,
                subtitle: t.assets.detail.notFoundBody,
                actionLabel: t.assets.list.title,
                onAction: () => context.pop(),
              ),
              AssetDetailLoaded(
                :final asset,
                :final history,
                :final priceHistory,
              ) =>
                AssetDetailContent(
                  asset: asset,
                  history: history,
                  priceHistory: priceHistory,
                ),
            },
          ),
        );
      },
    );
  }
}

String _typeLabel(AssetType type) {
  switch (type) {
    case AssetType.egpCash:
      return 'EGP Cash';
    case AssetType.usdCash:
      return 'USD';
    case AssetType.gold21:
      return 'Gold 21K';
    case AssetType.gold24:
      return 'Gold 24K';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_empty_state.dart';
import 'package:qeema/core/widgets/app_error_state.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';
import 'package:qeema/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:qeema/features/home/presentation/cubits/home_cubit/home_state.dart';
import 'package:qeema/features/home/presentation/widgets/asset_type_mini_card.dart';
import 'package:qeema/features/home/presentation/widgets/dashboard_skeleton.dart';
import 'package:qeema/features/home/presentation/widgets/dashboard_summary_card.dart';
import 'package:qeema/features/home/presentation/widgets/erosion_ring.dart';
import 'package:qeema/features/home/presentation/widgets/real_value_trend_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(t.home.title)),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeLoading() => const DashboardSkeleton(),
            HomeError(:final failure) => AppErrorState(
              message: failure.message,
              onRetry: () => context.read<HomeCubit>().loadDashboard(),
            ),
            HomeLoaded(:final summary) when !summary.hasAssets => AppEmptyState(
              icon: Icons.savings_outlined,
              title: t.assets.list.emptyNoAssets,
              subtitle: t.assets.list.emptyNoAssetsSubtitle,
              actionLabel: t.assets.list.addFirst,
              onAction: () => context.pushNamed(RouteNames.addAsset),
            ),
            HomeLoaded(:final summary) =>
              _DashboardContent(
                summary: summary,
              ),
          };
        },
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.summary,
  });

  final DashboardSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

    return RefreshIndicator(
      onRefresh: context.read<HomeCubit>().refresh,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          80 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          AppAnimatedEntry(
            type: EntryAnimationType.fadeSlideUp,
            child: DashboardSummaryCard(summary: summary),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppAnimatedEntry(
            type: EntryAnimationType.scaleIn,
            delay: const Duration(milliseconds: 100),
            child: ErosionRing(erosionPercent: summary.erosionPercent),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppAnimatedEntry(
            type: EntryAnimationType.fadeSlideUp,
            delay: const Duration(milliseconds: 200),
            child: AssetTypeMiniCardRow(summaries: summary.assetTypeSummaries),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppAnimatedEntry(
            type: EntryAnimationType.fadeSlideUp,
            delay: const Duration(milliseconds: 300),
            child: Text(
              t.home.trendSectionTitle,
              style: context.textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppAnimatedEntry(
            type: EntryAnimationType.fadeSlideUp,
            delay: const Duration(milliseconds: 350),
            child: RealValueTrendChart(trendData: summary.trend30Days),
          ),
        ],
      ),
    );
  }
}

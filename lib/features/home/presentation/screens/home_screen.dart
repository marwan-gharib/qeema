import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/features/assets/presentation/widgets/assets_empty_state.dart';
import 'package:qeema/features/home/presentation/cubit/home_cubit.dart';
import 'package:qeema/features/home/presentation/cubit/home_state.dart';
import 'package:qeema/features/home/presentation/widgets/asset_type_mini_card.dart';
import 'package:qeema/features/home/presentation/widgets/dashboard_error_state.dart';
import 'package:qeema/features/home/presentation/widgets/dashboard_loading_skeleton.dart';
import 'package:qeema/features/home/presentation/widgets/dashboard_summary_card.dart';
import 'package:qeema/features/home/presentation/widgets/erosion_ring.dart';
import 'package:qeema/features/home/presentation/widgets/price_move_banner.dart';
import 'package:qeema/features/home/presentation/widgets/real_value_trend_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final t = context.t;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(t.home.title)),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeInitial() || HomeLoading() => const DashboardLoadingSkeleton(),
            HomeError(message: final msg) => DashboardErrorState(message: msg),
            HomeLoaded(:final summary, :final shouldShowBanner) =>
              !summary.hasAssets
                  ? const AssetsEmptyState(isFiltered: false)
                  : RefreshIndicator(
                      onRefresh: context.read<HomeCubit>().refresh,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                        children: [
                          if (shouldShowBanner) const PriceMoveBanner(),
                          DashboardSummaryCard(summary: summary),
                          const SizedBox(height: 24),
                          ErosionRing(erosionPercent: summary.erosionPercent),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 116,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: summary.assetTypeSummaries.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) =>
                                  AssetTypeMiniCard(
                                    summary: summary.assetTypeSummaries[index],
                                  ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            t.home.trendSectionTitle,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: colors.textPrimary),
                          ),
                          const SizedBox(height: 8),
                          RealValueTrendChart(trendData: summary.trend30Days),
                        ],
                      ),
                    ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        onPressed: () => context.pushNamed(RouteNames.addAsset),
        child: const Icon(Icons.add),
      ),
    );
  }
}

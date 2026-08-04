import 'package:qeema/core/error/failures.dart';
import 'package:qeema/features/home/domain/entities/asset_type_summary_entity.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required this.summary, this.bannerDismissed = false});

  final DashboardSummaryEntity summary;
  final bool bannerDismissed;

  bool get shouldShowBanner {
    if (bannerDismissed) return false;
    return summary.assetTypeSummaries.any(
      (s) =>
          s.hasSufficientPriceHistory &&
          s.dayChangePercent.abs() >= kSignificantMoveThresholdPercent,
    );
  }

  HomeLoaded copyWith({bool? bannerDismissed}) {
    return HomeLoaded(
      summary: summary,
      bannerDismissed: bannerDismissed ?? this.bannerDismissed,
    );
  }
}

final class HomeError extends HomeState {
  const HomeError(this.failure);

  final Failure failure;
}

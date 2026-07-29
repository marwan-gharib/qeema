import 'package:qeema/features/home/domain/entities/asset_type_summary_entity.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';

sealed class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  const HomeLoaded({required this.summary, this.bannerDismissed = false});

  final DashboardSummaryEntity summary;
  final bool bannerDismissed;

  bool get shouldShowBanner {
    if (bannerDismissed) return false;
    return summary.assetTypeSummaries.any(
      (s) => s.dayChangePercent.abs() >= kSignificantMoveThresholdPercent,
    );
  }

  HomeLoaded copyWith({
    DashboardSummaryEntity? summary,
    bool? bannerDismissed,
  }) {
    return HomeLoaded(
      summary: summary ?? this.summary,
      bannerDismissed: bannerDismissed ?? this.bannerDismissed,
    );
  }
}

class HomeError extends HomeState {
  const HomeError(this.message);

  final String message;
}

import 'package:qeema/core/error/failures.dart';
import 'package:qeema/features/home/domain/entities/dashboard_summary_entity.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({required this.summary});

  final DashboardSummaryEntity summary;
}

final class HomeError extends HomeState {
  const HomeError(this.failure);

  final Failure failure;
}

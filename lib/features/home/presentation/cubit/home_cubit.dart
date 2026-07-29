import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/utils/api_result.dart';
import 'package:qeema/features/home/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:qeema/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.getDashboardSummaryUseCase) : super(const HomeInitial());

  final GetDashboardSummaryUseCase getDashboardSummaryUseCase;

  Future<void> loadDashboard() async {
    emit(const HomeLoading());
    final result = await getDashboardSummaryUseCase();
    if (isClosed) return;

    switch (result) {
      case Success(data: final summary):
        emit(HomeLoaded(summary: summary));
      case ResultFailure(failure: final failure):
        emit(HomeError(failure.message ?? 'Something went wrong'));
    }
  }

  Future<void> refresh() => loadDashboard();

  void dismissBanner() {
    final current = state;
    if (current is! HomeLoaded) return;
    emit(current.copyWith(bannerDismissed: true));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/features/home/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:qeema/features/home/presentation/cubits/home_cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getDashboardSummaryUseCase) : super(const HomeLoading());

  final GetDashboardSummaryUseCase _getDashboardSummaryUseCase;

  Future<void> loadDashboard() async {
    emit(const HomeLoading());
    final result = await _getDashboardSummaryUseCase.call();
    if (isClosed) return;

    result.fold(
      onSuccess: (summary) => emit(HomeLoaded(summary: summary)),
      onFailure: (failure) => emit(HomeError(failure)),
    );
  }

  Future<void> refresh() => loadDashboard();

  void dismissBanner() {
    final current = state;
    if (current is! HomeLoaded) return;
    emit(current.copyWith(bannerDismissed: true));
  }
}

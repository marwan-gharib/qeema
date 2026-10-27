import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/domain/asset_type.dart';
import 'package:qeema/features/assets/domain/usecases/get_assets_usecase.dart';
import 'package:qeema/features/assets/domain/usecases/refresh_assets_usecase.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_state.dart';

class AssetsListCubit extends Cubit<AssetsListState> {
  AssetsListCubit(this.getAssetsUseCase, this.refreshAssetsUseCase)
    : super(const AssetsListInitial());

  final GetAssetsUseCase getAssetsUseCase;
  final RefreshAssetsUseCase refreshAssetsUseCase;

  Future<void> loadAssets() async {
    emit(const AssetsListLoading());
    final result = await getAssetsUseCase();
    if (isClosed) return;

    result.fold(
      onSuccess: (assets) => emit(AssetsListLoaded(allAssets: assets)),
      onFailure: (failure) => emit(AssetsListError(failure)),
    );
  }

  Future<void> refresh() async {
    // Network-first: pull-to-refresh must fetch fresh data, with the cache
    // serving as the offline fallback inside the repository.
    final result = await refreshAssetsUseCase();
    if (isClosed) return;

    result.fold(
      onSuccess: (assets) => emit(AssetsListLoaded(allAssets: assets)),
      onFailure: (failure) => emit(AssetsListError(failure)),
    );
  }

  void changeFilter(AssetType? type) {
    final current = state;
    if (current is! AssetsListLoaded) return;
    emit(current.copyWith(activeFilter: type, clearFilter: type == null));
  }

  void changeSort(AssetsSortBy sortBy) {
    final current = state;
    if (current is! AssetsListLoaded) return;
    emit(current.copyWith(sortBy: sortBy));
  }
}

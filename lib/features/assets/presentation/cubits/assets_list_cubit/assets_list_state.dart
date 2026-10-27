import 'package:qeema/core/domain/asset_type.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

enum AssetsSortBy { dateNewest, dateOldest, valueHighest, valueLowest }

sealed class AssetsListState {
  const AssetsListState();
}

class AssetsListInitial extends AssetsListState {
  const AssetsListInitial();
}

class AssetsListLoading extends AssetsListState {
  const AssetsListLoading();
}

class AssetsListLoaded extends AssetsListState {
  const AssetsListLoaded({
    required this.allAssets,
    this.activeFilter,
    this.sortBy = AssetsSortBy.dateNewest,
  });

  final List<AssetEntity> allAssets;
  final AssetType? activeFilter;
  final AssetsSortBy sortBy;

  List<AssetEntity> get visibleAssets {
    // Copy before sorting: allAssets may be an unmodifiable (const) list, and
    // a getter must never mutate its state.
    final list = activeFilter == null
        ? allAssets.toList()
        : allAssets.where((a) => a.assetType == activeFilter).toList();

    list.sort((a, b) {
      switch (sortBy) {
        case AssetsSortBy.dateNewest:
          return b.entryDate.compareTo(a.entryDate);
        case AssetsSortBy.dateOldest:
          return a.entryDate.compareTo(b.entryDate);
        case AssetsSortBy.valueHighest:
          return (b.currentValue ?? 0).compareTo(a.currentValue ?? 0);
        case AssetsSortBy.valueLowest:
          return (a.currentValue ?? 0).compareTo(b.currentValue ?? 0);
      }
    });
    return list;
  }

  AssetsListLoaded copyWith({
    List<AssetEntity>? allAssets,
    AssetType? activeFilter,
    bool clearFilter = false,
    AssetsSortBy? sortBy,
  }) {
    return AssetsListLoaded(
      allAssets: allAssets ?? this.allAssets,
      activeFilter: clearFilter ? null : (activeFilter ?? this.activeFilter),
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class AssetsListError extends AssetsListState {
  const AssetsListError(this.failure);

  final Failure failure;
}

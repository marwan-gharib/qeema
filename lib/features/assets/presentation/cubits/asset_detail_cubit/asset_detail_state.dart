import 'package:qeema/core/error/failures.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_history_entry_entity.dart';

sealed class AssetDetailState {
  const AssetDetailState();
}

class AssetDetailInitial extends AssetDetailState {
  const AssetDetailInitial();
}

class AssetDetailLoading extends AssetDetailState {
  const AssetDetailLoading();
}

class AssetDetailLoaded extends AssetDetailState {
  const AssetDetailLoaded({required this.asset, required this.history});

  final AssetEntity asset;
  final List<AssetHistoryEntryEntity> history;
}

class AssetDetailNotFound extends AssetDetailState {
  const AssetDetailNotFound();
}

class AssetDetailError extends AssetDetailState {
  const AssetDetailError(this.failure);
  final Failure failure;
}

class AssetDetailHistoryLoading extends AssetDetailLoaded {
  const AssetDetailHistoryLoading({
    required super.asset,
    super.history = const [],
  });
}

class AssetDetailHistoryError extends AssetDetailLoaded {
  const AssetDetailHistoryError({
    required super.asset,
    super.history = const [],
  });
}

import 'package:decimal/decimal.dart';
import 'package:qeema/core/error/failures.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';

class EditAssetState {
  const EditAssetState({
    this.isLoading = true,
    this.originalAsset,
    this.amount,
    this.priceAtEntry,
    this.entryDate,
    this.note,
    this.isFormValid = false,
    this.loadFailure,
    this.isSubmitting = false,
    this.submitFailure,
    this.submitSucceeded = false,
    this.updatedEntity,
  });

  factory EditAssetState.fromAsset(AssetEntity asset) {
    return EditAssetState(
      isLoading: false,
      originalAsset: asset,
      amount: Decimal.tryParse(asset.amount.toString()),
      priceAtEntry: Decimal.tryParse(asset.priceAtEntry.toString()),
      entryDate: asset.entryDate,
      note: asset.note,
      isFormValid: true,
    );
  }

  final bool isLoading;
  final AssetEntity? originalAsset;
  final Decimal? amount;
  final Decimal? priceAtEntry;
  final DateTime? entryDate;
  final String? note;
  final bool isFormValid;
  final Failure? loadFailure;
  final bool isSubmitting;
  final Failure? submitFailure;
  final bool submitSucceeded;
  final AssetEntity? updatedEntity;

  bool get hasChanges {
    if (originalAsset == null) return false;
    final asset = originalAsset!;

    final origAmount = Decimal.tryParse(asset.amount.toString());
    if (amount != origAmount) return true;

    final origPrice = Decimal.tryParse(asset.priceAtEntry.toString());
    if (priceAtEntry != origPrice) return true;

    if (entryDate != null) {
      if (entryDate!.year != asset.entryDate.year ||
          entryDate!.month != asset.entryDate.month ||
          entryDate!.day != asset.entryDate.day) {
        return true;
      }
    }

    final trimmedNote = note?.trim();
    final currentNote = (trimmedNote == null || trimmedNote.isEmpty)
        ? null
        : trimmedNote;
    final originalNote = asset.note?.trim();
    if (currentNote != originalNote) return true;

    return false;
  }

  EditAssetState copyWith({
    bool? isLoading,
    AssetEntity? originalAsset,
    bool clearLoadFailure = false,
    Failure? loadFailure,
    bool? isSubmitting,
    bool clearSubmitFailure = false,
    Failure? submitFailure,
    bool? submitSucceeded,
    bool clearUpdatedEntity = false,
    AssetEntity? updatedEntity,
    Decimal? amount,
    Decimal? priceAtEntry,
    DateTime? entryDate,
    String? note,
    bool? isFormValid,
  }) {
    return EditAssetState(
      isLoading: isLoading ?? this.isLoading,
      originalAsset: originalAsset ?? this.originalAsset,
      amount: amount ?? this.amount,
      priceAtEntry: priceAtEntry ?? this.priceAtEntry,
      entryDate: entryDate ?? this.entryDate,
      note: note ?? this.note,
      isFormValid: isFormValid ?? this.isFormValid,
      loadFailure: clearLoadFailure ? null : (loadFailure ?? this.loadFailure),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitFailure: clearSubmitFailure
          ? null
          : (submitFailure ?? this.submitFailure),
      submitSucceeded: submitSucceeded ?? this.submitSucceeded,
      updatedEntity: clearUpdatedEntity
          ? null
          : (updatedEntity ?? this.updatedEntity),
    );
  }
}

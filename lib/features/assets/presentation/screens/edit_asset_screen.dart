import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/animations/micro_interactions/success_pulse.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_error_state.dart';
import 'package:qeema/core/widgets/app_snackbar.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/domain/params/update_asset_params.dart';
import 'package:qeema/features/assets/presentation/cubits/edit_asset_cubit/edit_asset_cubit.dart';
import 'package:qeema/features/assets/presentation/cubits/edit_asset_cubit/edit_asset_state.dart';
import 'package:qeema/features/assets/presentation/widgets/dynamic_asset_fields.dart';

class EditAssetScreen extends StatefulWidget {
  const EditAssetScreen({super.key});

  @override
  State<EditAssetScreen> createState() => _EditAssetScreenState();
}

class _EditAssetScreenState extends State<EditAssetScreen> {
  final _amountController = TextEditingController();
  final _priceController = TextEditingController();
  final _noteController = TextEditingController();
  var _ready = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
    _priceController.addListener(_onPriceChanged);
    _noteController.addListener(_onNoteChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _priceController.removeListener(_onPriceChanged);
    _noteController.removeListener(_onNoteChanged);
    _amountController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    if (!_ready) return;
    if (!mounted) return;
    final text = _amountController.text;
    context.read<EditAssetCubit>().updateAmount(
      text.trim().isNotEmpty ? Decimal.tryParse(text.trim()) : null,
    );
  }

  void _onPriceChanged() {
    if (!_ready) return;
    if (!mounted) return;
    final text = _priceController.text.trim();
    context.read<EditAssetCubit>().updatePriceAtEntry(
      text.isNotEmpty ? Decimal.tryParse(text) : null,
    );
  }

  void _onNoteChanged() {
    if (!_ready) return;
    if (!mounted) return;
    context.read<EditAssetCubit>().updateNote(_noteController.text);
  }

  void _submit(EditAssetCubit cubit) {
    if (cubit.state.isSubmitting) return;

    final asset = cubit.state.originalAsset;
    if (asset == null) return;

    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) return;

    cubit.submit(
      UpdateAssetParams(
        assetId: asset.id,
        amount: Decimal.parse(amountText),
        priceAtEntry: _priceController.text.trim().isNotEmpty
            ? Decimal.parse(_priceController.text.trim())
            : null,
        entryDate: cubit.state.entryDate ?? asset.entryDate,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      ),
    );
  }

  AssetTypeEntity _makeTypeEntity(AssetEntity asset) {
    final isMarketBased = switch (asset.assetType) {
      AssetType.egpCash => false,
      AssetType.usdCash => true,
      AssetType.gold21 => true,
      AssetType.gold24 => true,
    };
    final (String code, String name, String unit) = switch (asset.assetType) {
      AssetType.egpCash => ('cash_egp', 'EGP Cash', 'EGP'),
      AssetType.usdCash => ('usd', 'USD', 'USD'),
      AssetType.gold21 => ('gold_21', 'Gold 21K', 'gram'),
      AssetType.gold24 => ('gold_24', 'Gold 24K', 'gram'),
    };
    return AssetTypeEntity(
      id: code,
      code: code,
      name: name,
      isMarketBased: isMarketBased,
      baseUnit: unit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return BlocConsumer<EditAssetCubit, EditAssetState>(
      listener: (context, state) {
        if (state.submitFailure != null) {
          AppSnackBar.showError(
            context,
            state.submitFailure!.message ?? t.core.failure.unknownFailure,
          );
        }
        if (state.submitSucceeded) {
          final amount = double.tryParse(_amountController.text);
          final price = double.tryParse(_priceController.text);
          Future.delayed(const Duration(milliseconds: 400), () {
            if (context.mounted) {
              context.pop(
                amount != null && price != null ? (amount, price) : null,
              );
            }
          });
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.loadFailure != null) {
          return Scaffold(
            appBar: AppBar(),
            body: AppErrorState(
              message: state.loadFailure!.message,
              onRetry: () => context.read<EditAssetCubit>().loadAsset(),
            ),
          );
        }

        final asset = state.originalAsset!;
        final typeEntity = _makeTypeEntity(asset);
        final colors = context.colors;

        if (!_ready) {
          _amountController.text = asset.amount.toString();
          _priceController.text = asset.priceAtEntry.toString();
          if (asset.note != null) _noteController.text = asset.note!;
          _ready = true;
        }

        return Scaffold(
          appBar: AppBar(title: Text(typeEntity.name)),
          body: SuccessPulse(
            triggered: state.submitSucceeded,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.surfaceAlt,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _iconForType(asset.assetType),
                          size: 24,
                          color: colors.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.assets.edit.assetTypeLabel,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                            Text(
                              typeEntity.name,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DynamicAssetFields(
                    key: ValueKey('edit_fields_${asset.id}'),
                    selectedType: typeEntity,
                    amountController: _amountController,
                    priceController: _priceController,
                    noteController: _noteController,
                    entryDate: state.entryDate,
                    onEntryDateChanged: (date) =>
                        context.read<EditAssetCubit>().updateEntryDate(date),
                    onFormValidityChanged: (valid) => context
                        .read<EditAssetCubit>()
                        .updateFormValidity(valid),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: t.assets.edit.submit,
                    isLoading: state.isSubmitting,
                    onPressed:
                        state.isFormValid &&
                            state.hasChanges &&
                            !state.isSubmitting
                        ? () => _submit(context.read<EditAssetCubit>())
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _iconForType(AssetType type) {
    switch (type) {
      case AssetType.egpCash:
        return Icons.payments_outlined;
      case AssetType.usdCash:
        return Icons.attach_money;
      case AssetType.gold21:
      case AssetType.gold24:
        return Icons.monetization_on_outlined;
    }
  }
}

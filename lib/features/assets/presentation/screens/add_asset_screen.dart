import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/animations/micro_interactions/success_pulse.dart';
import 'package:qeema/core/extensions/failure_localization_extension.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_snackbar.dart';
import 'package:qeema/features/assets/domain/params/add_asset_params.dart';
import 'package:qeema/features/assets/presentation/cubits/add_asset_cubit/add_asset_cubit.dart';
import 'package:qeema/features/assets/presentation/cubits/add_asset_cubit/add_asset_state.dart';
import 'package:qeema/features/assets/presentation/widgets/add_asset_skeleton.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_type_picker.dart';
import 'package:qeema/features/assets/presentation/widgets/dynamic_asset_fields.dart';

class AddAssetScreen extends StatefulWidget {
  const AddAssetScreen({super.key});

  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  final _amountController = TextEditingController();
  final _priceController = TextEditingController();
  final _noteController = TextEditingController();
  var _entryDate = DateTime.now();
  var _formValid = false;

  @override
  void dispose() {
    _amountController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final cubit = context.read<AddAssetCubit>();
    final type = cubit.state.selectedType;
    if (type == null || cubit.state.isSubmitting) return;

    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) return;

    final priceText = _priceController.text.trim();

    cubit.submit(
      AddAssetParams(
        assetTypeId: type.id,
        amount: Decimal.parse(amountText),
        priceAtEntry: type.isMarketBased && priceText.isNotEmpty
            ? Decimal.parse(priceText)
            : null,
        entryDate: _entryDate,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return BlocConsumer<AddAssetCubit, AddAssetState>(
      listener: (context, state) {
        if (state.submitFailure != null) {
          AppSnackBar.showError(
            context,
            state.submitFailure!.localizedMessage(context),
          );
        }
        if (state.submitSucceeded) {
          Future.delayed(const Duration(milliseconds: 400), () {
            if (context.mounted) context.pop();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(t.assets.add.title)),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AddAssetState state) {
    final content = state.isLoadingTypes
        ? const AddAssetSkeleton(key: ValueKey('skeleton'))
        : _buildForm(context, state);

    if (MediaQuery.of(context).disableAnimations) return content;

    return AnimatedSwitcher(duration: AppMotion.normal, child: content);
  }

  Widget _buildForm(BuildContext context, AddAssetState state) {
    final t = context.t;
    final showSuccess = state.submitSucceeded;

    return SuccessPulse(
      key: const ValueKey('form'),
      triggered: showSuccess,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AssetTypePicker(assetTypes: state.availableTypes),
            if (state.selectedType != null) ...[
              DynamicAssetFields(
                selectedType: state.selectedType!,
                amountController: _amountController,
                priceController: _priceController,
                noteController: _noteController,
                entryDate: _entryDate,
                onEntryDateChanged: (date) => setState(() => _entryDate = date),
                onFormValidityChanged: (valid) =>
                    setState(() => _formValid = valid),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: t.assets.add.submit,
              isLoading: state.isSubmitting,
              onPressed:
                  !state.isSubmitting &&
                      state.selectedType != null &&
                      _formValid
                  ? _submit
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/helpers/validators.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_text_field.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';
import 'package:qeema/features/assets/presentation/blocs/assets_bloc/assets_bloc.dart';
import 'package:qeema/features/assets/presentation/blocs/assets_bloc/assets_event.dart';
import 'package:qeema/features/assets/presentation/blocs/assets_bloc/assets_state.dart';
import 'package:qeema/features/assets/presentation/widgets/asset_type_picker.dart';

class AddAssetScreen extends StatefulWidget {
  const AddAssetScreen({super.key});

  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  final _amountController = TextEditingController();
  final _priceController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AssetTypeEntity? _selectedType;
  List<AssetTypeEntity> _assetTypes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<AssetsBloc>().state;
    if (state is AssetsLoadSuccess && _assetTypes.isEmpty) {
      _assetTypes = state.assetTypes;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.assets.add.title)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              context.t.assets.add.selectType,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            AssetTypePicker(
              assetTypes: _assetTypes,
              selectedId: _selectedType?.id,
              onSelected: (type) {
                setState(() => _selectedType = type);
              },
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: _amountController,
              label: context.t.assets.add.amount,
              hint: '0.00',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) => Validators.amount(
                v,
                requiredMsg: context.t.assets.add.amountRequired,
                invalidMsg: context.t.assets.add.amountInvalid,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _priceController,
              label: context.t.assets.add.priceAtEntry,
              hint: '0.00 EGP',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) => Validators.amount(
                v,
                requiredMsg: context.t.assets.add.priceRequired,
                invalidMsg: context.t.assets.add.priceInvalid,
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _noteController,
              label: context.t.assets.add.note,
              hint: context.t.assets.add.noteHint,
            ),
            const SizedBox(height: 32),
            AppButton(
              label: context.t.assets.add.submit,
              onPressed: _selectedType == null ? null : _onSubmit,
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) return;

    final amount = Decimal.parse(_amountController.text);
    final price = Decimal.parse(_priceController.text);

    context.read<AssetsBloc>().add(
      AssetAdded(
        assetTypeId: _selectedType!.id,
        assetTypeCode: _selectedType!.code,
        amount: amount,
        priceAtEntry: price,
        entryDate: DateTime.now(),
        note: _noteController.text.isEmpty ? null : _noteController.text,
      ),
    );
    context.pop();
  }
}

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/helpers/validators.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/widgets/app_button.dart';
import 'package:qeema/core/widgets/app_text_field.dart';
import 'package:qeema/features/assets/domain/entities/asset_entity.dart';
import 'package:qeema/features/assets/presentation/blocs/assets_bloc/assets_bloc.dart';
import 'package:qeema/features/assets/presentation/blocs/assets_bloc/assets_event.dart';

class EditAssetScreen extends StatefulWidget {
  const EditAssetScreen({super.key, required this.asset});
  final AssetEntity asset;

  @override
  State<EditAssetScreen> createState() => _EditAssetScreenState();
}

class _EditAssetScreenState extends State<EditAssetScreen> {
  late final TextEditingController _amountController;
  late final TextEditingController _priceController;
  late final TextEditingController _noteController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.asset.amount.toString(),
    );
    _priceController = TextEditingController(
      text: widget.asset.priceAtEntry.toString(),
    );
    _noteController = TextEditingController(text: widget.asset.note ?? '');
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
      appBar: AppBar(
        title: Text(
          context.t.assets.edit.title.replaceAll(
            '{type}',
            widget.asset.assetTypeCode.toUpperCase(),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
              label: context.t.assets.edit.submit,
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final amount = Decimal.parse(_amountController.text);
    final price = Decimal.parse(_priceController.text);

    context.read<AssetsBloc>().add(
      AssetUpdated(
        id: widget.asset.id,
        amount: amount,
        priceAtEntry: price,
        note: _noteController.text.isEmpty ? null : _noteController.text,
      ),
    );
    context.pop();
  }
}

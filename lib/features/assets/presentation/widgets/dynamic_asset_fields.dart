import 'package:flutter/material.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
import 'package:qeema/core/helpers/date_formatter.dart';
import 'package:qeema/core/helpers/validators.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_text_field.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';

class DynamicAssetFields extends StatefulWidget {
  const DynamicAssetFields({
    super.key,
    required this.selectedType,
    required this.amountController,
    required this.priceController,
    required this.noteController,
    this.entryDate,
    this.onEntryDateChanged,
    required this.onFormValidityChanged,
    this.priceHint,
  });

  final AssetTypeEntity selectedType;
  final TextEditingController amountController;
  final TextEditingController priceController;
  final TextEditingController noteController;
  final DateTime? entryDate;
  final ValueChanged<DateTime>? onEntryDateChanged;
  final ValueChanged<bool> onFormValidityChanged;
  final String? priceHint;

  @override
  State<DynamicAssetFields> createState() => _DynamicAssetFieldsState();
}

class _DynamicAssetFieldsState extends State<DynamicAssetFields> {
  final _dateController = TextEditingController();
  var _amountTouched = false;
  var _priceTouched = false;

  @override
  void initState() {
    super.initState();
    _updateDateText();
  }

  @override
  void didUpdateWidget(DynamicAssetFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entryDate != widget.entryDate) {
      _updateDateText();
    }
  }

  void _updateDateText() {
    if (widget.entryDate != null) {
      _dateController.text = DateFormatter.format(widget.entryDate!);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _validate() {
    final amountText = widget.amountController.text;
    final amountValid =
        _amountTouched &&
        Validators.amount(amountText, requiredMsg: '', invalidMsg: '') == null;

    final priceValid =
        !widget.selectedType.isMarketBased ||
        (_priceTouched &&
            Validators.amount(
                  widget.priceController.text,
                  requiredMsg: '',
                  invalidMsg: '',
                ) ==
                null);

    widget.onFormValidityChanged(amountValid && priceValid);
  }

  String? _amountError(String? value) {
    if (!_amountTouched) return null;
    return Validators.amount(
      value,
      requiredMsg: context.t.assets.add.amountRequired,
      invalidMsg: context.t.assets.add.amountInvalid,
    );
  }

  String? _priceError(String? value) {
    if (!_priceTouched) return null;
    return Validators.amount(
      value,
      requiredMsg: context.t.assets.add.priceRequired,
      invalidMsg: context.t.assets.add.priceInvalid,
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.entryDate ?? now,
      firstDate: DateTime(2000),
      lastDate: now,
      helpText: context.t.assets.add.selectDate,
    );
    if (picked != null) {
      widget.onEntryDateChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.selectedType;
    final t = context.t.assets.add;
    final unit = type.baseUnit;

    return AppAnimatedEntry(
      type: EntryAnimationType.fadeSlideUp,
      key: ValueKey('fields_${type.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            controller: widget.amountController,
            label: '${t.amount} ($unit)',
            hint: '0.00',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: const Icon(Icons.numbers),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: _amountError,
            onChanged: (_) {
              _amountTouched = true;
              _validate();
            },
          ),
          const SizedBox(height: AppSpacing.md),
          if (type.isMarketBased) ...[
            AppTextField(
              controller: widget.priceController,
              label: '${t.priceAtEntry} (EGP per $unit)',
              hint: widget.priceHint ?? '0.00',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              prefixIcon: const Icon(Icons.currency_exchange),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              enabled: true,
              validator: _priceError,
              onChanged: (_) {
                _priceTouched = true;
                _validate();
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          GestureDetector(
            onTap: _pickDate,
            child: AbsorbPointer(
              child: AppTextField(
                controller: _dateController,
                label: t.entryDate,
                hint: DateFormatter.format(DateTime.now()),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: widget.noteController,
            label: t.note,
            hint: t.noteHint,
            prefixIcon: const Icon(Icons.edit_note),
          ),
        ],
      ),
    );
  }
}

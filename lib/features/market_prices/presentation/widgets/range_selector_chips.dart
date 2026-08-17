import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/features/market_prices/presentation/cubits/market_price_detail_cubit/market_price_detail_state.dart';

class RangeSelectorChips extends StatelessWidget {
  const RangeSelectorChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MarketPriceRangeOption selected;
  final ValueChanged<MarketPriceRangeOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final t = context.t.marketPrices.range;

    return Row(
      children: [
        _chip(context, t.oneWeek, MarketPriceRangeOption.oneWeek),
        const SizedBox(width: 8),
        _chip(context, t.oneMonth, MarketPriceRangeOption.oneMonth),
        const SizedBox(width: 8),
        _chip(context, t.threeMonths, MarketPriceRangeOption.threeMonths),
      ],
    );
  }

  Widget _chip(
    BuildContext context,
    String label,
    MarketPriceRangeOption option,
  ) {
    final colors = context.colors;
    final isSelected = option == selected;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(option),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      labelStyle: context.textTheme.labelMedium?.copyWith(
        color: isSelected ? colors.primary : colors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : null,
      ),
      backgroundColor: colors.surfaceAlt,
      selectedColor: colors.primary.withValues(alpha: 0.12),
      side: BorderSide(color: isSelected ? colors.primary : colors.divider),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

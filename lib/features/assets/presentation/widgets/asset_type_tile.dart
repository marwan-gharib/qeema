import 'package:flutter/material.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';

class AssetTypeTile extends StatelessWidget {
  const AssetTypeTile({
    super.key,
    required this.type,
    required this.isSelected,
  });

  final AssetTypeEntity type;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildIconWithBadge(context),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              type.name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : null,
              ),
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle, color: colors.primary, size: 24),
        ],
      ),
    );
  }

  Widget _buildIconWithBadge(BuildContext context) {
    final colors = context.colors;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(iconForType(type.code), size: 28, color: colors.textPrimary),
        if (type.code.startsWith('gold_'))
          Positioned(
            right: -10,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                type.code == 'gold_21' ? '21K' : '24K',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  static IconData iconForType(String code) {
    switch (code) {
      case 'cash_egp':
        return Icons.payments_outlined;
      case 'usd':
        return Icons.attach_money;
      case 'gold_21':
      case 'gold_24':
        return Icons.monetization_on_outlined;
      default:
        return Icons.account_balance_outlined;
    }
  }
}

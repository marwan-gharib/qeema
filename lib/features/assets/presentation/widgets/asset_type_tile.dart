import 'package:flutter/material.dart';
import 'package:qeema/core/animations/micro_interactions/tap_scale.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/assets/domain/entities/asset_type_entity.dart';

class AssetTypeTile extends StatelessWidget {
  const AssetTypeTile({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final AssetTypeEntity type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TapScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.primary : colors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  _iconForType(type.code),
                  size: 32,
                  color: isSelected ? colors.onPrimary : colors.textPrimary,
                ),
                if (type.code.startsWith('gold_'))
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? colors.onPrimary : colors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        type.code == 'gold_21' ? '21K' : '24K',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? colors.primary : colors.onPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              type.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? colors.onPrimary : colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(String code) {
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

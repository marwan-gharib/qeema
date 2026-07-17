import 'package:flutter/material.dart';
import 'package:qeema/core/theme/app_spacing.dart';

class MoneyValueIllustration extends StatelessWidget {
  const MoneyValueIllustration({
    super.key,
    required this.primary,
    required this.primaryVariant,
    required this.error,
    required this.textSecondary,
    required this.iconColor,
  });
  final Color primary;
  final Color primaryVariant;
  final Color error;
  final Color textSecondary;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [primary, primaryVariant]),
          ),
          child: Icon(Icons.monetization_on, size: 60, color: iconColor),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.trending_down, color: error, size: 32),
            const SizedBox(width: AppSpacing.xs),
            Icon(Icons.arrow_forward, color: textSecondary, size: 24),
          ],
        ),
      ],
    );
  }
}

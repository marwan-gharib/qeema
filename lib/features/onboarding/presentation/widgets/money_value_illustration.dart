import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_sizes.dart';
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
          width: Responsive.width(120),
          height: Responsive.height(120),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [primary, primaryVariant]),
          ),
          child: Icon(
            Icons.monetization_on,
            size: AppSizes.iconIllustration,
            color: iconColor,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.trending_down, color: error, size: AppSizes.iconXl),
            SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.arrow_forward,
              color: textSecondary,
              size: AppSizes.iconStandard,
            ),
          ],
        ),
      ],
    );
  }
}

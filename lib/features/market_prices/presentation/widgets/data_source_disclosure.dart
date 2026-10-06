import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_sizes.dart';
import 'package:qeema/core/theme/app_spacing.dart';

/// One-line, shown once per screen — prices come from international spot /
/// official exchange rates and may differ from local market or goldsmith
/// prices. Kept small and unobtrusive, never repeated per card.
class DataSourceDisclosure extends StatelessWidget {
  const DataSourceDisclosure({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: AppSizes.iconInline,
            color: colors.textSecondary,
          ),
          SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              t.marketPrices.dataSourceDisclosure,
              style: context.textStyles.footnote.copyWith(
                color: colors.textSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

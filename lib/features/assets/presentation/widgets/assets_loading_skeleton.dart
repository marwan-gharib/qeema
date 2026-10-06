import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_borders.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_spacing.dart';

class AssetsLoadingSkeleton extends StatelessWidget {
  const AssetsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      itemCount: 6,
      separatorBuilder: (_, _) => const Divider(height: AppBorders.hairline),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              Container(
                width: Responsive.adapt(40),
                height: Responsive.adapt(40),
                decoration: BoxDecoration(
                  color: colors.divider.withAlpha(60),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Responsive.height(14),
                      width: Responsive.width(120),
                      decoration: BoxDecoration(
                        color: colors.divider.withAlpha(80),
                        borderRadius: BorderRadius.circular(AppRadius.xxs),
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Container(
                      height: Responsive.height(12),
                      width: Responsive.width(80),
                      decoration: BoxDecoration(
                        color: colors.divider.withAlpha(50),
                        borderRadius: BorderRadius.circular(AppRadius.xxs),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: Responsive.height(14),
                    width: Responsive.width(80),
                    decoration: BoxDecoration(
                      color: colors.divider.withAlpha(80),
                      borderRadius: BorderRadius.circular(AppRadius.xxs),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Container(
                    height: Responsive.height(20),
                    width: Responsive.width(60),
                    decoration: BoxDecoration(
                      color: colors.divider.withAlpha(50),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

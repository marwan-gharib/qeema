import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_sizes.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.action,
    this.container = false,
    this.height,
    this.margin,
    this.padding,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? action;
  final bool container;
  final double? height;
  final EdgeInsetsGeometry? margin;

  /// Defaults to [AppSpacing.xl] all around; `null` means the default.
  final EdgeInsetsGeometry? padding;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectivePadding = padding ?? EdgeInsets.all(AppSpacing.xl);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: container ? AppSizes.iconHero : AppSizes.iconState,
          color: container
              ? colors.textSecondary.withAlpha(100)
              : iconColor ?? context.colorScheme.primary.withValues(alpha: 0.5),
        ),
        SizedBox(height: container ? AppSpacing.sm : AppSpacing.md),
        Text(
          title,
          style: container
              ? context.textTheme.titleSmall?.copyWith(
                  color: colors.textPrimary,
                )
              : titleStyle ?? context.textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            subtitle!,
            style: container
                ? context.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  )
                : subtitleStyle ?? context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
        if (action != null || (actionLabel != null && onAction != null)) ...[
          SizedBox(height: container ? AppSpacing.sm : AppSpacing.lg),
          action ?? AppButton(label: actionLabel!, onPressed: onAction),
        ],
      ],
    );

    if (!container) {
      return Center(
        child: Padding(padding: effectivePadding, child: content),
      );
    }

    return Container(
      height: height == null ? null : Responsive.height(height!),
      margin: margin ?? EdgeInsets.zero,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: FittedBox(fit: BoxFit.scaleDown, child: content),
    );
  }
}

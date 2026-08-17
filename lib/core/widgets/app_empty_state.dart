import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
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
    this.padding = const EdgeInsets.all(32),
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
  final EdgeInsetsGeometry padding;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: container ? 48 : 64,
          color: container
              ? colors.textSecondary.withAlpha(100)
              : iconColor ?? context.colorScheme.primary.withValues(alpha: 0.5),
        ),
        SizedBox(height: container ? AppSpacing.sm : 16),
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
          SizedBox(height: container ? AppSpacing.xs : 8),
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
          SizedBox(height: container ? AppSpacing.sm : 24),
          action ?? AppButton(label: actionLabel!, onPressed: onAction),
        ],
      ],
    );

    if (!container) {
      return Center(
        child: Padding(padding: padding, child: content),
      );
    }

    return Container(
      height: height,
      margin: margin ?? EdgeInsets.zero,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: FittedBox(fit: BoxFit.scaleDown, child: content),
    );
  }
}

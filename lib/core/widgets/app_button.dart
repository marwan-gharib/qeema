import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/theme/app_borders.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_sizes.dart';
import 'package:qeema/core/theme/app_spacing.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutline = false,
    this.isText = false,
    this.backgroundColor,
    this.prefixWidget,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutline;
  final bool isText;
  final Color? backgroundColor;
  final Widget? prefixWidget;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (isText) {
      return TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: backgroundColor ?? colors.primary,
          minimumSize: const Size.fromHeight(AppSizes.minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: AppSizes.loader,
                height: AppSizes.loader,
                child: const CircularProgressIndicator(
                  strokeWidth: AppBorders.emphasis,
                ),
              )
            : Text(label),
      );
    }

    if (isOutline) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: backgroundColor ?? colors.primary,
          side: BorderSide(color: backgroundColor ?? colors.primary),
          minimumSize: const Size.fromHeight(AppSizes.minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: AppSizes.loader,
                height: AppSizes.loader,
                child: const CircularProgressIndicator(
                  strokeWidth: AppBorders.emphasis,
                ),
              )
            : Text(label),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? colors.primary,
        foregroundColor: context.colorScheme.onPrimary,
        minimumSize: const Size.fromHeight(AppSizes.minTouchTarget),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: AppSizes.loader,
              height: AppSizes.loader,
              child: CircularProgressIndicator(
                strokeWidth: AppBorders.emphasis,
                color: context.colorScheme.onPrimary,
              ),
            )
          : prefixWidget != null
          ? Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.sm,
                children: [prefixWidget!, Text(label)],
              ),
            )
          : Text(label),
    );
  }
}

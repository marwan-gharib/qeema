import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_sizes.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_button.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({super.key, this.message, this.onRetry});
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: AppSizes.iconState,
              color: context.colorScheme.error,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              message ?? context.t.core.error.body,
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: AppSpacing.lg),
              AppButton(
                label: context.t.core.error.tryAgain,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

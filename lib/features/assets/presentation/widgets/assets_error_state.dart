import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/core/theme/app_sizes.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/assets/presentation/cubits/assets_list_cubit/assets_list_cubit.dart';

class AssetsErrorState extends StatelessWidget {
  const AssetsErrorState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;
    final t = context.t;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: AppSizes.iconState,
              color: colors.error,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              t.core.error.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: colors.textPrimary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => context.read<AssetsListCubit>().loadAssets(),
              icon: const Icon(Icons.refresh),
              label: Text(t.core.error.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}

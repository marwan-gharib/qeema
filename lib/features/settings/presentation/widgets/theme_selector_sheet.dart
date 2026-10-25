import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/micro_interactions/tap_scale.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/settings/presentation/widgets/selector_option_row.dart';

class ThemeSelectorSheet extends StatelessWidget {
  const ThemeSelectorSheet({super.key, required this.currentMode});

  static Future<void> show(BuildContext context, ThemeMode currentMode) {
    return showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
      ),
      builder: (_) => ThemeSelectorSheet(currentMode: currentMode),
    );
  }

  final ThemeMode currentMode;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.settings.themeSheetTitle,
              style: context.textTheme.titleMedium,
            ),
            SizedBox(height: AppSpacing.md),
            for (final (mode, label) in [
              (ThemeMode.light, t.settings.themeLight),
              (ThemeMode.dark, t.settings.themeDark),
              (ThemeMode.system, t.settings.themeSystem),
            ])
              Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.xs),
                child: TapScale(
                  onTap: () {
                    context.read<ThemeCubit>().setThemeMode(mode);
                    context.pop(context);
                  },
                  child: SelectorOptionRow(
                    label: label,
                    isSelected: currentMode == mode,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

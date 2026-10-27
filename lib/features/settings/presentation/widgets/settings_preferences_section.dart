import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_state.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_state.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/features/settings/presentation/widgets/language_selector_sheet.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_tile.dart';
import 'package:qeema/features/settings/presentation/widgets/theme_selector_sheet.dart';

/// Language and theme rows; the current value is shown on the row and picked
/// through the selector sheets.
class SettingsPreferencesSection extends StatelessWidget {
  const SettingsPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return SettingsSectionCard(
      header: t.settings.preferencesSection,
      tiles: [
        BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, state) {
            final languageLabel = switch (state.locale) {
              AppLocale.en => t.settings.languageEnglish,
              AppLocale.ar => t.settings.languageArabic,
            };
            return SettingsTile(
              icon: Icons.language,
              label: t.settings.language,
              onTap: () => LanguageSelectorSheet.show(context, state.locale),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    languageLabel,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            );
          },
        ),
        BlocBuilder<ThemeCubit, AppThemeState>(
          builder: (context, state) {
            final modeLabel = switch (state.mode) {
              ThemeMode.light => t.settings.themeLight,
              ThemeMode.dark => t.settings.themeDark,
              ThemeMode.system => t.settings.themeSystem,
            };
            return SettingsTile(
              icon: Icons.palette_outlined,
              label: t.settings.theme,
              onTap: () => ThemeSelectorSheet.show(context, state.mode),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    modeLabel,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

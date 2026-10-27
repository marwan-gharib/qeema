import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_radius.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/settings/presentation/widgets/app_version_tile.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_tile.dart';

/// App version plus the data-methodology note, opened as a bottom sheet.
class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return SettingsSectionCard(
      header: t.settings.aboutSection,
      tiles: [
        const AppVersionTile(),
        SettingsTile(
          icon: Icons.info_outline,
          label: t.settings.dataMethodology,
          onTap: () => _showMethodologySheet(context),
          trailing: Icon(
            Icons.chevron_right,
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showMethodologySheet(BuildContext context) {
    final t = context.t;

    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Text(
              t.settings.dataMethodologyNote,
              style: sheetContext.textTheme.bodyMedium?.copyWith(
                color: sheetContext.colors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }
}

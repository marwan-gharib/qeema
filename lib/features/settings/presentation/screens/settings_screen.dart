import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_state.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_state.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_surface_card.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_toggle_tile.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_state.dart';
import 'package:qeema/features/settings/presentation/widgets/delete_account_dialog.dart';
import 'package:qeema/features/settings/presentation/widgets/language_selector_sheet.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_section_header.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_tile.dart';
import 'package:qeema/features/settings/presentation/widgets/theme_selector_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(t.settings.title)),
      body: BlocListener<DeleteAccountCubit, DeleteAccountState>(
        listenWhen: (previous, current) => current is DeleteAccountSuccess,
        listener: (context, state) => context.go(RoutePaths.onboarding),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.md,
            80 + MediaQuery.paddingOf(context).bottom,
          ),
          children: [
            AppAnimatedEntry(
              type: EntryAnimationType.fadeSlideUp,
              child: _buildSecuritySection(context),
            ),
            AppAnimatedEntry(
              type: EntryAnimationType.fadeSlideUp,
              child: _buildPreferencesSection(context),
            ),
            AppAnimatedEntry(
              type: EntryAnimationType.fadeSlideUp,
              child: _buildAboutSection(context),
            ),
            AppAnimatedEntry(
              type: EntryAnimationType.fadeSlideUp,
              child: _buildDangerZoneSection(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return _buildSection(
      context: context,
      header: context.t.settings.securitySection,
      tiles: const [AppLockToggleTile()],
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    final t = context.t;

    return _buildSection(
      context: context,
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

  Widget _buildAboutSection(BuildContext context) {
    final t = context.t;

    return _buildSection(
      context: context,
      header: t.settings.aboutSection,
      tiles: [
        const _AppVersionTile(),
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

  Widget _buildDangerZoneSection(BuildContext context) {
    final t = context.t;

    return _buildSection(
      context: context,
      header: t.settings.dangerZoneSection,
      tiles: [
        SettingsTile(
          icon: Icons.delete_outline,
          label: t.settings.deleteAccount,
          isDestructive: true,
          onTap: () => DeleteAccountDialog.show(context),
        ),
      ],
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String header,
    required List<Widget> tiles,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsSectionHeader(label: header),
        AppSurfaceCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                tiles[i],
                if (i < tiles.length - 1)
                  const Divider(height: 1, indent: 56, endIndent: AppSpacing.md),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _showMethodologySheet(BuildContext context) {
    final t = context.t;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
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

class _AppVersionTile extends StatefulWidget {
  const _AppVersionTile();

  @override
  State<_AppVersionTile> createState() => _AppVersionTileState();
}

class _AppVersionTileState extends State<_AppVersionTile> {
  String? _version;
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _version = '${info.version} (${info.buildNumber})';
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: Icons.info_outline,
      label: context.t.settings.appVersion,
      trailing: _loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : _version == null
          ? null
          : Text(
              _version!,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
    );
  }
}

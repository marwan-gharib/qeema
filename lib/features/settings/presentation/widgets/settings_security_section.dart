import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_state.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_tile.dart';

/// The app-lock row: a spinner while loading, the failure message on error, and
/// the enable switch once the setting is known.
class SettingsSecuritySection extends StatelessWidget {
  const SettingsSecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return SettingsSectionCard(
      header: t.settings.securitySection,
      tiles: [
        BlocBuilder<AppLockSettingsCubit, AppLockSettingsState>(
          builder: (context, state) {
            final cubit = context.read<AppLockSettingsCubit>();
            return switch (state) {
              AppLockSettingsLoading() => SettingsTile(
                icon: Icons.lock_outline,
                label: t.app_lock.settingsTitle,
                trailing: SizedBox(
                  width: AppSpacing.md,
                  height: AppSpacing.md,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              AppLockSettingsFailure() => SettingsTile(
                icon: Icons.lock_outline,
                label: t.app_lock.settingsTitle,
                subtitle: t.app_lock.errorMessage,
              ),
              AppLockSettingsLoaded() => SettingsTile(
                icon: Icons.lock_outline,
                label: t.app_lock.settingsTitle,
                subtitle: state.deviceLockAvailable
                    ? t.app_lock.settingsSubtitle
                    : t.app_lock.settingsNoDeviceLock,
                trailing: Switch(
                  value: state.deviceLockAvailable && state.isEnabled,
                  onChanged: !state.deviceLockAvailable || state.isBusy
                      ? null
                      : cubit.setEnabled,
                ),
              ),
            };
          },
        ),
      ],
    );
  }
}

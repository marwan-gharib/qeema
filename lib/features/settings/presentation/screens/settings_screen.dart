import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/app_animated_entry.dart';
import 'package:qeema/core/animations/entry_animation_type.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/core/widgets/app_content_box.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/app_lock_settings_cubit/app_lock_settings_state.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/delete_account_cubit/delete_account_state.dart';
import 'package:qeema/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:qeema/features/settings/presentation/cubits/logout_cubit/logout_state.dart';
import 'package:qeema/features/settings/presentation/widgets/profile_header_card.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_about_section.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_danger_zone_section.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_preferences_section.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_security_section.dart';

/// The settings tab: profile header, then one animated section per concern
/// (preferences, security, about, danger zone). Logout and account deletion
/// navigate back to the welcome route; an app-lock toggle change refreshes the
/// lock cubit.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(t.settings.title)),
      body: MultiBlocListener(
        listeners: [
          BlocListener<DeleteAccountCubit, DeleteAccountState>(
            listenWhen: (previous, current) => current is DeleteAccountSuccess,
            listener: (context, state) {
              if (!context.mounted) return;
              context.go(RoutePaths.welcome);
            },
          ),
          BlocListener<LogoutCubit, LogoutState>(
            listenWhen: (previous, current) => current is LogoutSuccess,
            listener: (context, state) {
              if (!context.mounted) return;
              context.go(RoutePaths.welcome);
            },
          ),
          BlocListener<AppLockSettingsCubit, AppLockSettingsState>(
            listenWhen: (previous, current) => switch ((previous, current)) {
              (final AppLockSettingsLoaded p, final AppLockSettingsLoaded c) =>
                p.isEnabled != c.isEnabled,
              _ => false,
            },
            listener: (context, state) {
              if (!context.mounted) return;
              unawaited(context.read<AppLockCubit>().refresh());
            },
          ),
        ],
        child: AppContentBox(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              Responsive.height(80) + MediaQuery.paddingOf(context).bottom,
            ),
            children: const [
              AppAnimatedEntry(
                type: EntryAnimationType.fadeSlideUp,
                child: ProfileHeaderCard(),
              ),
              AppAnimatedEntry(
                type: EntryAnimationType.fadeSlideUp,
                child: SettingsPreferencesSection(),
              ),
              AppAnimatedEntry(
                type: EntryAnimationType.fadeSlideUp,
                child: SettingsSecuritySection(),
              ),
              AppAnimatedEntry(
                type: EntryAnimationType.fadeSlideUp,
                child: SettingsAboutSection(),
              ),
              AppAnimatedEntry(
                type: EntryAnimationType.fadeSlideUp,
                child: SettingsDangerZoneSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

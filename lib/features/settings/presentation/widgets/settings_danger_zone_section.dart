import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/features/settings/presentation/cubits/logout_cubit/logout_cubit.dart';
import 'package:qeema/features/settings/presentation/widgets/delete_account_dialog.dart';
import 'package:qeema/features/settings/presentation/widgets/logout_dialog.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_section_card.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_tile.dart';

/// Destructive rows: log out (guest-aware) and delete the account.
class SettingsDangerZoneSection extends StatelessWidget {
  const SettingsDangerZoneSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return SettingsSectionCard(
      header: t.settings.dangerZoneSection,
      tiles: [
        SettingsTile(
          icon: Icons.logout,
          label: t.settings.logout,
          isDestructive: true,
          onTap: () {
            final cubit = context.read<LogoutCubit>();
            LogoutDialog.show(context, isGuest: cubit.isCurrentUserAnonymous());
          },
        ),
        SettingsTile(
          icon: Icons.delete_outline,
          label: t.settings.deleteAccount,
          isDestructive: true,
          onTap: () => DeleteAccountDialog.show(context),
        ),
      ],
    );
  }
}

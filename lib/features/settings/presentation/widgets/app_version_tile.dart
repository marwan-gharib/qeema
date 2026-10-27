import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/settings/presentation/widgets/settings_tile.dart';

/// The app-version row: a spinner until `PackageInfo` resolves, the
/// "version (build)" string afterwards, and nothing if the lookup fails.
class AppVersionTile extends StatefulWidget {
  const AppVersionTile({super.key});

  @override
  State<AppVersionTile> createState() => _AppVersionTileState();
}

class _AppVersionTileState extends State<AppVersionTile> {
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
          ? SizedBox(
              width: AppSpacing.md,
              height: AppSpacing.md,
              child: const CircularProgressIndicator(strokeWidth: 2),
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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/micro_interactions/tap_scale.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/settings/presentation/widgets/selector_option_row.dart';

class LanguageSelectorSheet extends StatelessWidget {
  const LanguageSelectorSheet({super.key, required this.currentLocale});

  static Future<void> show(BuildContext context, AppLocale currentLocale) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => LanguageSelectorSheet(currentLocale: currentLocale),
    );
  }

  final AppLocale currentLocale;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.settings.languageSheetTitle,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final (locale, label) in [
              (AppLocale.en, t.settings.languageEnglish),
              (AppLocale.ar, t.settings.languageArabic),
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: TapScale(
                  onTap: () {
                    context.read<LocaleCubit>().setLocale(locale);
                    Navigator.pop(context);
                  },
                  child: SelectorOptionRow(
                    label: label,
                    isSelected: currentLocale == locale,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

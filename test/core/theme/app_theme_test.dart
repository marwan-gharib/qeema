import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/theme/app_colors_extension.dart';
import 'package:qeema/core/theme/app_theme.dart';

void main() {
  final lightTheme = AppTheme.light();

  test('configures semantic component themes for light mode', () {
    final colors = lightTheme.extension<AppColorsExtension>()!.asAppColors;

    expect(lightTheme.dialogTheme.backgroundColor, colors.surface);
    expect(lightTheme.bottomSheetTheme.modalBackgroundColor, colors.surface);
    expect(lightTheme.snackBarTheme.backgroundColor, colors.surfaceAlt);
    expect(lightTheme.iconTheme.color, colors.textPrimary);
    expect(lightTheme.colorScheme.onPrimary, colors.onPrimary);
    expect(lightTheme.colorScheme.onError, colors.textPrimary);
  });

  test('preserves the original dark primary foreground', () {
    final darkTheme = AppTheme.dark();
    final colors = darkTheme.extension<AppColorsExtension>()!.asAppColors;

    expect(colors.onPrimary, const Color(0xFFFFFFFF));
    expect(
      darkTheme.elevatedButtonTheme.style!.foregroundColor!.resolve({}),
      colors.onPrimary,
    );
  });

  testWidgets(
    'renders light dialog, bottom sheet, and snackbar without exceptions',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: lightTheme,
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  TextButton(
                    onPressed: () => showDialog<void>(
                      context: context,
                      builder: (_) => const AlertDialog(
                        title: Text('Dialog'),
                        content: Text('Dialog content'),
                      ),
                    ),
                    child: const Text('dialog'),
                  ),
                  TextButton(
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      builder: (_) => const SizedBox(
                        height: 80,
                        child: Text('Sheet content'),
                      ),
                    ),
                    child: const Text('sheet'),
                  ),
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Snackbar content')),
                    ),
                    child: const Text('snackbar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('dialog'));
      await tester.pumpAndSettle();
      expect(find.text('Dialog content'), findsOneWidget);
      await tester.tapAt(const Offset(0, 0));
      await tester.pumpAndSettle();

      await tester.tap(find.text('sheet'));
      await tester.pumpAndSettle();
      expect(find.text('Sheet content'), findsOneWidget);
      await tester.tapAt(const Offset(0, 0));
      await tester.pumpAndSettle();

      await tester.tap(find.text('snackbar'));
      await tester.pump();
      expect(find.text('Snackbar content'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/navigation/bottom_nav_bar.dart';
import 'package:qeema/core/navigation/bottom_nav_item_config.dart';
import 'package:qeema/core/router/app_router.dart';
import 'package:qeema/core/theme/app_theme.dart';

const _barLeft = 24.0; // margin AppSpacing.lg

/// Half of the badge lift applied in bottom_nav_bar.dart
/// (`-_badgeLift / 2`), so the badge sits slightly inside the bar.
const _badgeHalfLift = 12.0;

/// Badge icon center for the tab at [index], measured from the real bar
/// rect so the expectation holds for any test surface size.
double _expectedBadgeDx(WidgetTester tester, int index) {
  final bar = tester.getRect(find.byType(BottomNavBar));
  final itemCount = BottomNavItemConfig.items.length;
  final itemWidth = (bar.width - _barLeft * 2) / itemCount;
  return bar.left + _barLeft + itemWidth * (index + 0.5);
}

Widget _harness({
  required int currentIndex,
  required ValueChanged<int> onTap,
  bool reduceMotion = false,
  TextDirection direction = TextDirection.ltr,
}) {
  return TranslationProvider(
    child: Directionality(
      textDirection: direction,
      child: MediaQuery(
        data: MediaQueryData(disableAnimations: reduceMotion),
        child: Theme(
          data: AppTheme.light(),
          child: BottomNavBar(currentIndex: currentIndex, onTap: onTap),
        ),
      ),
    ),
  );
}

class _IndexedNavBar extends StatefulWidget {
  const _IndexedNavBar({this.reduceMotion = false});

  final bool reduceMotion;

  @override
  State<_IndexedNavBar> createState() => _IndexedNavBarState();
}

class _IndexedNavBarState extends State<_IndexedNavBar> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return _harness(
      currentIndex: _index,
      onTap: (index) => setState(() => _index = index),
      reduceMotion: widget.reduceMotion,
    );
  }
}

void main() {
  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  group('BottomNavBar taps', () {
    testWidgets('tapping an unselected tab reports its index', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(
        _harness(currentIndex: 0, onTap: (index) => tappedIndex = index),
      );

      await tester.tap(find.text('Assets'));
      expect(tappedIndex, 1);
    });

    testWidgets('tapping the selected tab reports its index', (tester) async {
      var tappedIndex = -1;
      await tester.pumpWidget(
        _harness(currentIndex: 0, onTap: (index) => tappedIndex = index),
      );

      await tester.tap(find.text('Home'));
      expect(tappedIndex, 0);
    });
  });

  group('BottomNavBar badge', () {
    testWidgets('renders above the selected tab', (tester) async {
      await tester.pumpWidget(_harness(currentIndex: 1, onTap: (_) {}));

      final badgeCenter = tester.getCenter(find.byIcon(Icons.pie_chart));
      final bar = tester.getRect(find.byType(BottomNavBar));
      expect(badgeCenter.dx, closeTo(_expectedBadgeDx(tester, 1), 1));
      expect(badgeCenter.dy, closeTo(bar.top + _badgeHalfLift, 0.5));
    });

    testWidgets('travels to the newly selected tab on switch', (tester) async {
      await tester.pumpWidget(const _IndexedNavBar());

      expect(
        tester.getCenter(find.byIcon(Icons.home)).dx,
        closeTo(_expectedBadgeDx(tester, 0), 1),
      );

      await tester.tap(find.text('Assets'));
      await tester.pumpAndSettle();

      expect(
        tester.getCenter(find.byIcon(Icons.pie_chart)).dx,
        closeTo(_expectedBadgeDx(tester, 1), 1),
      );
    });

    testWidgets('reduced motion snaps the badge into place immediately', (
      tester,
    ) async {
      await tester.pumpWidget(const _IndexedNavBar(reduceMotion: true));

      await tester.tap(find.text('Assets'));
      await tester.pump();

      expect(
        tester.getCenter(find.byIcon(Icons.pie_chart)).dx,
        closeTo(_expectedBadgeDx(tester, 1), 1),
      );
    });

    testWidgets('mirrors tab order in RTL', (tester) async {
      await tester.pumpWidget(
        _harness(currentIndex: 0, onTap: (_) {}, direction: TextDirection.rtl),
      );

      final badgeDx = tester.getCenter(find.byIcon(Icons.home)).dx;
      final barCenterDx = tester.getRect(find.byType(BottomNavBar)).center.dx;
      expect(badgeDx, greaterThan(barCenterDx));
    });
  });

  group('BottomNavBar structural sync', () {
    test('item count matches the shell route branches', () {
      expect(
        BottomNavItemConfig.items.length,
        AppRouter.shellRoute.branches.length,
      );
    });
  });
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_state.dart';
import 'package:qeema/features/app_lock/presentation/screens/lock_screen.dart';

/// Wraps the application root to shield the running screens behind an overlay
/// when the app lock gate is closed, and defers mounting the router on cold
/// start until the initial gate decision is reached.
class AppLockOverlay extends StatefulWidget {
  const AppLockOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<AppLockOverlay> createState() => _AppLockOverlayState();
}

class _AppLockOverlayState extends State<AppLockOverlay>
    with WidgetsBindingObserver {
  static const Key _childSubtreeKey = ValueKey('app_lock_router_child_subtree');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    final cubit = context.read<AppLockCubit>();
    if (cubit.isLocked) {
      // Consume system back events while locked so neither the overlay
      // nor the Navigator underneath is popped.
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppLockCubit, AppLockState>(
      listenWhen: (previous, current) =>
          previous is! AppLockLocked && current is AppLockLocked,
      listener: (context, state) {
        // Drop focus and dismiss the soft keyboard immediately upon lock so
        // input cannot leak or keep the virtual keyboard visible.
        FocusManager.instance.primaryFocus?.unfocus();
      },
      builder: (context, state) {
        final cubit = context.read<AppLockCubit>();
        final isLocked = cubit.isLocked;

        // Cold start flow: the router child is not mounted until the initial
        // open-gate decision completes, preventing the splash screen from
        // running behind the lock screen.
        if (!cubit.hasCompletedFirstEntry) {
          if (state is AppLockInitial || state is AppLockChecking) {
            // Neutral container while initial evaluation runs so the lock UI
            // is never flashed if App Lock is disabled.
            return Scaffold(
              backgroundColor: context.colors.background,
              body: const SizedBox.expand(),
            );
          }
          return const LockScreen();
        }

        // Running app flow: the router child remains permanently mounted at
        // index 0 with stable keys and types across all lock/unlock cycles.
        return Stack(
          fit: StackFit.expand,
          children: [
            TickerMode(
              enabled: !isLocked,
              child: ExcludeSemantics(
                excluding: isLocked,
                child: AbsorbPointer(
                  absorbing: isLocked,
                  child: FocusScope(
                    canRequestFocus: !isLocked,
                    child: KeyedSubtree(
                      key: _childSubtreeKey,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
            if (isLocked)
              const Positioned.fill(
                key: ValueKey('app_lock_overlay_screen'),
                child: LockScreen(),
              ),
          ],
        );
      },
    );
  }
}

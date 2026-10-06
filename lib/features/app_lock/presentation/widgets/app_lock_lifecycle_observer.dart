import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';

/// Bridges OS lifecycle events into [AppLockCubit]: backgrounding re-locks
/// and foregrounding re-evaluates the gate only while it is actually closed
/// — prompt-driven resumes arriving with an open gate are ignored.
class AppLockLifecycleObserver extends StatefulWidget {
  const AppLockLifecycleObserver({super.key, required this.child});
  final Widget child;

  @override
  State<AppLockLifecycleObserver> createState() =>
      _AppLockLifecycleObserverState();
}

class _AppLockLifecycleObserverState extends State<AppLockLifecycleObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(context.read<AppLockCubit>().onAppResumed());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    final appLock = context.read<AppLockCubit>();
    if (appLock.isLocked) {
      // Consume system back gestures while locked so screens below are never
      // popped or revealed.
      return true;
    }
    return false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final appLock = context.read<AppLockCubit>();
    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(appLock.onAppResumed());
      // Only actual backgrounding re-locks: `inactive` also fires for
      // transient system dialogs, which must not bounce the user to /lock.
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        appLock.onAppPaused();
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

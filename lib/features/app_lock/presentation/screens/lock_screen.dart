import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/cubits/lock_cubit/lock_state.dart';
import 'package:qeema/features/app_lock/presentation/widgets/lock_screen_body.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key, required this.onUnlocked, this.lockCubit});

  final VoidCallback onUnlocked;
  final LockCubit? lockCubit;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  late final LockCubit _cubit;
  bool _hasBiometrics = false;

  @override
  void initState() {
    super.initState();
    _cubit = widget.lockCubit ?? getIt<LockCubit>();
    _checkBiometrics();
    WidgetsBinding.instance.addPostFrameCallback((_) => _triggerAuth());
  }

  Future<void> _checkBiometrics() async {
    final canCheck = await _cubit.canCheckBiometrics;
    if (mounted) setState(() => _hasBiometrics = canCheck);
  }

  void _triggerAuth() {
    _cubit.authenticate(localizedReason: context.t.core.auth.unlockReason);
  }

  @override
  void dispose() {
    if (widget.lockCubit == null) {
      _cubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<LockCubit, AppLockState>(
        listenWhen: (previous, current) => current is AppLockUnlocked,
        listener: (context, state) => widget.onUnlocked(),
        child: Scaffold(
          body: LockScreenBody(
            onRetry: _triggerAuth,
            hasBiometrics: _hasBiometrics,
          ),
        ),
      ),
    );
  }
}

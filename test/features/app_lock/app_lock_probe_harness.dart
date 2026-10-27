import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart' hide GlobalMaterialLocalizations;
import 'package:mocktail/mocktail.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/theme/app_theme.dart';
import 'package:qeema/features/app_lock/domain/usecases/authenticate_device_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/check_device_lock_available_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/get_app_lock_enabled_usecase.dart';
import 'package:qeema/features/app_lock/domain/usecases/set_recents_preview_hidden_usecase.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_lifecycle_observer.dart';
import 'package:qeema/features/app_lock/presentation/widgets/app_lock_overlay.dart';

class FakeGetAppLockEnabledUseCase extends Mock
    implements GetAppLockEnabledUseCase {}

class FakeCheckDeviceLockAvailableUseCase extends Mock
    implements CheckDeviceLockAvailableUseCase {}

class FakeAuthenticateDeviceUseCase extends Mock
    implements AuthenticateDeviceUseCase {}

class FakeSetRecentsPreviewHiddenUseCase extends Mock
    implements SetRecentsPreviewHiddenUseCase {}

class ProbeCubit extends Cubit<int> {
  ProbeCubit() : super(0) {
    createCount++;
  }
  static int createCount = 0;
  static int closeCount = 0;
  static int loadDataCalls = 0;

  static void resetCounts() {
    createCount = 0;
    closeCount = 0;
    loadDataCalls = 0;
  }

  void loadData() {
    loadDataCalls++;
    emit(state + 1);
  }

  @override
  Future<void> close() {
    closeCount++;
    return super.close();
  }
}

class ProbeScreen extends StatefulWidget {
  const ProbeScreen({super.key});

  @override
  State<ProbeScreen> createState() => ProbeScreenState();
}

class ProbeScreenState extends State<ProbeScreen> {
  static int initCount = 0;
  static int disposeCount = 0;
  static ProbeScreenState? lastInstance;
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  int tapCount = 0;

  static void resetCounts() {
    initCount = 0;
    disposeCount = 0;
    lastInstance = null;
  }

  @override
  void initState() {
    super.initState();
    initCount++;
    lastInstance = this;
  }

  @override
  void dispose() {
    disposeCount++;
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Probe State: ${context.watch<ProbeCubit>().state}'),
            TextField(
              key: const ValueKey('probe_text_field'),
              controller: textController,
              focusNode: focusNode,
            ),
            ElevatedButton(
              key: const ValueKey('probe_button'),
              onPressed: () {
                setState(() {
                  tapCount++;
                });
              },
              child: Text('Tapped: $tapCount'),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashProbe extends StatefulWidget {
  const SplashProbe({super.key});

  static int buildCount = 0;

  @override
  State<SplashProbe> createState() => _SplashProbeState();
}

class _SplashProbeState extends State<SplashProbe> {
  @override
  Widget build(BuildContext context) {
    SplashProbe.buildCount++;
    return const Scaffold(body: Text('Splash Probe'));
  }
}

Widget buildAppWithOverlay({
  required AppLockCubit appLockCubit,
  required GoRouter router,
}) {
  return BlocProvider<AppLockCubit>.value(
    value: appLockCubit,
    child: TranslationProvider(
      child: AppLockLifecycleObserver(
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light(),
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          builder: (context, child) => child == null
              ? const SizedBox.shrink()
              : AppLockOverlay(child: child),
        ),
      ),
    ),
  );
}

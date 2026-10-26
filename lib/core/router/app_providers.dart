import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qeema/core/cubits/locale_cubit/locale_cubit.dart';
import 'package:qeema/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:qeema/core/di/injection_container.dart';
import 'package:qeema/features/app_lock/presentation/cubits/app_lock_cubit/app_lock_cubit.dart';

/// App-scoped cubit providers that must live above the router.
///
/// Owns the `getIt` resolutions for the global cubits so `main.dart` stays
/// free of DI calls (DI-4 allows `getIt` only under `core/di/` and here, in
/// the router's `BlocProvider(create: ...)` zone).
class AppProviders extends StatelessWidget {
  const AppProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LocaleCubit>()),
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<AppLockCubit>()),
      ],
      child: child,
    );
  }
}

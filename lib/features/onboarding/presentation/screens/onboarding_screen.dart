import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/extensions/build_context_extensions.dart';
import 'package:qeema/core/router/route_paths.dart';
import 'package:qeema/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:qeema/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_state.dart';
import 'package:qeema/features/onboarding/presentation/widgets/onboarding_page_view.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        switch (state) {
          case OnboardingCompleted():
            context.go(RoutePaths.login);
          default:
            break;
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colors.primary, colors.background],
            ),
          ),
          child: const SafeArea(child: OnboardingPageView()),
        ),
      ),
    );
  }
}

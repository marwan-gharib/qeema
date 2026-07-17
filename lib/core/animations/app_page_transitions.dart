import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_motion.dart';

Page<void> fadeThroughPage({required Widget child, required LocalKey pageKey}) {
  return CustomTransitionPage<void>(
    key: pageKey,
    child: child,
    transitionDuration: AppMotion.normal,
    reverseTransitionDuration: AppMotion.normal,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: AppMotion.standard).animate(animation),
        child: child,
      );
    },
  );
}

Page<void> slideUpPage({required Widget child, required LocalKey pageKey}) {
  return CustomTransitionPage<void>(
    key: pageKey,
    child: child,
    transitionDuration: AppMotion.slow,
    reverseTransitionDuration: AppMotion.fast,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: animation,
                curve: AppMotion.entrance,
                reverseCurve: AppMotion.exit,
              ),
            ),
        child: child,
      );
    },
  );
}

Page<void> sharedAxisPage({
  required Widget child,
  required LocalKey pageKey,
  required bool forward,
}) {
  return CustomTransitionPage<void>(
    key: pageKey,
    child: child,
    transitionDuration: AppMotion.normal,
    reverseTransitionDuration: AppMotion.normal,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offset = forward ? const Offset(0.25, 0) : const Offset(-0.25, 0);
      return SlideTransition(
        position: Tween<Offset>(begin: offset, end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: AppMotion.standard),
        ),
        child: FadeTransition(
          opacity: CurveTween(curve: AppMotion.standard).animate(animation),
          child: child,
        ),
      );
    },
  );
}

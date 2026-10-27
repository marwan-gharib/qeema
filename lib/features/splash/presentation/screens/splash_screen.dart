import 'dart:async';
import 'dart:math' as math;

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qeema/core/animations/app_entrance_sequence.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/animations/app_oscillating_animation.dart';
import 'package:qeema/core/animations/app_rotating_animation.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/responsive/responsive.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/splash/presentation/widgets/logo_3d_flip.dart';
import 'package:qeema/features/splash/presentation/widgets/logo_energy_ring.dart';
import 'package:qeema/features/splash/presentation/widgets/logo_pulse_glow.dart';
import 'package:qeema/features/splash/presentation/widgets/splash_background.dart';
import 'package:qeema/features/splash/presentation/widgets/splash_brand_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasNavigated = false;
  bool _didSchedule = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didSchedule) return;
    _didSchedule = true;
    if (MediaQuery.of(context).disableAnimations) {
      _navigateOnce();
    } else {
      Future<void>.delayed(AppMotion.splashSequence, _navigateOnce);
    }
  }

  void _navigateOnce() {
    if (_hasNavigated) return;
    _hasNavigated = true;
    if (mounted) {
      context.goNamed(RouteNames.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppEntranceSequence(
      duration: AppMotion.splashSequence,
      builder: (context, values) {
        return Stack(
          alignment: Alignment.center,
          children: [
            AppOscillatingAnimation(
              builder: (context, breath) => SplashBackground(
                breathValue: breath,
                rotationValue: values.phase1 * math.pi,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Responsive.adapt(200),
                  height: Responsive.adapt(200),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AppRotatingAnimation(
                        builder: (context, turns) => LogoEnergyRing(
                          rotationTurns: turns,
                          isReducedMotion: false,
                        ),
                      ),
                      AppOscillatingAnimation(
                        builder: (context, pulse) =>
                            LogoPulseGlow(pulseValue: pulse),
                      ),
                      Logo3DFlip(
                        logoRotationY: values.phase1 * math.pi / 2,
                        logoScale: values.phase1.clamp(0.0, 1.0),
                        logoOpacity: values.phase1.clamp(0.0, 1.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                SplashBrandText(
                  textOpacity: values.phase2.clamp(0.0, 1.0),
                  textSlide: Offset(
                    0,
                    (1 - values.phase2.clamp(0.0, 1.0)) * 0.5,
                  ),
                  textScale: (0.96 + values.phase2.clamp(0.0, 1.0) * 0.04),
                  appName: context.t.app.name,
                  tagline: context.t.app.tagline,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

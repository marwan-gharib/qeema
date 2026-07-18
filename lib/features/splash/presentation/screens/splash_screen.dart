import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qeema/core/animations/app_motion.dart';
import 'package:qeema/core/i18n/strings.g.dart';
import 'package:qeema/core/router/route_names.dart';
import 'package:qeema/core/theme/app_spacing.dart';
import 'package:qeema/features/splash/presentation/widgets/logo_3d_flip.dart';
import 'package:qeema/features/splash/presentation/widgets/logo_energy_ring.dart';
import 'package:qeema/features/splash/presentation/widgets/logo_pulse_glow.dart';
import 'package:qeema/features/splash/presentation/widgets/splash_background.dart';
import 'package:qeema/features/splash/presentation/widgets/splash_brand_text.dart';

const double _heroContainerSize = 200.0;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgBreathController;
  late final AnimationController _sequenceController;
  late final AnimationController _pulseController;
  late final AnimationController _ringRotationController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoRotationY;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textScale;

  bool _isReducedMotion = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isReducedMotion = MediaQuery.of(context).disableAnimations;
    _startAnimationSequence();
    if (_isReducedMotion) {
      _navigateOnce();
    } else {
      Future<void>.delayed(AppMotion.splashSequence, _navigateOnce);
    }
  }

  void _initializeAnimations() {
    _bgBreathController = AnimationController(
      vsync: this,
      duration: AppMotion.heroSlow,
    );

    _sequenceController = AnimationController(
      vsync: this,
      duration: AppMotion.hero,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: AppMotion.heroPulse,
    );

    _ringRotationController = AnimationController(
      vsync: this,
      duration: AppMotion.heroSlow,
    );

    _logoRotationY = Tween<double>(begin: math.pi / 2, end: 0.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.5, curve: AppMotion.emphasized),
      ),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.5, curve: AppMotion.emphasized),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.0, 0.5, curve: AppMotion.entrance),
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.6, 1.0, curve: AppMotion.entrance),
      ),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _sequenceController,
            curve: const Interval(0.6, 1.0, curve: AppMotion.entrance),
          ),
        );

    _textScale = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _sequenceController,
        curve: const Interval(0.6, 1.0, curve: AppMotion.entrance),
      ),
    );
  }

  void _startAnimationSequence() {
    unawaited(_bgBreathController.repeat(reverse: true));
    unawaited(_sequenceController.forward());

    Future<void>.delayed(AppMotion.heroDelay, () {
      if (mounted) {
        unawaited(_pulseController.repeat());
        unawaited(_ringRotationController.repeat());
      }
    });
  }

  void _navigateOnce() {
    if (_hasNavigated) return;
    _hasNavigated = true;
    if (mounted) {
      context.goNamed(RouteNames.onboarding);
    }
  }

  @override
  void dispose() {
    _bgBreathController.dispose();
    _sequenceController.dispose();
    _pulseController.dispose();
    _ringRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SplashBackground(
            breathAnimation: _bgBreathController,
            rotationYAnimation: _logoRotationY,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: _heroContainerSize,
                height: _heroContainerSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    LogoEnergyRing(
                      rotationAnimation: _ringRotationController,
                      isReducedMotion: false,
                    ),
                    LogoPulseGlow(pulseAnimation: _pulseController),
                    Logo3DFlip(
                      logoRotationY: _logoRotationY,
                      logoScale: _logoScale,
                      logoOpacity: _logoOpacity,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SplashBrandText(
                textOpacity: _textOpacity,
                textSlide: _textSlide,
                textScale: _textScale,
                appName: context.t.app.name,
                tagline: context.t.app.tagline,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

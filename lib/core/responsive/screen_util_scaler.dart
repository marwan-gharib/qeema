import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:qeema/core/responsive/responsive_scaler.dart';

/// THE ONLY file in `lib/` allowed to import `package:flutter_screenutil`.
///
/// Replaceability: to swap or remove the package, rewrite this file so
/// [createResponsiveScaler] returns another [ResponsiveScaler] implementation
/// (or `const IdentityResponsiveScaler()`) and drop the dependency from
/// `pubspec.yaml`. No other file references the package or its extensions.
ResponsiveScaler createResponsiveScaler() => ScreenUtilScaler._();

class ScreenUtilScaler extends ResponsiveScaler {
  ScreenUtilScaler._();

  bool _configured = false;
  double _scaleWidth = 1;
  double _scaleHeight = 1;
  double _scaleAdaptive = 1;

  @override
  bool get isInitialized => _configured;

  @override
  void configure(MediaQueryData metrics, {required Size designSize}) {
    if (metrics.size.isEmpty) {
      _configured = false;
      return;
    }

    // splitScreenMode/minTextAdapt must be passed on the first call: 5.9.3
    // reads those late fields when an argument is null.
    ScreenUtil.configure(
      data: metrics,
      designSize: designSize,
      splitScreenMode: false,
      minTextAdapt: true,
      fontSizeResolver: FontSizeResolvers.width,
    );

    final screen = ScreenUtil();
    _scaleWidth = _clamp(screen.scaleWidth);
    _scaleHeight = _clamp(screen.scaleHeight);
    _scaleAdaptive = _clamp(math.min(screen.scaleWidth, screen.scaleHeight));
    _configured = true;
  }

  @override
  double width(double value) => _configured ? value * _scaleWidth : value;

  @override
  double height(double value) => _configured ? value * _scaleHeight : value;

  @override
  double radius(double value) => _configured ? value * _scaleAdaptive : value;

  @override
  double font(double value) => _configured ? value * _scaleAdaptive : value;

  @override
  double adapt(double value) => _configured ? value * _scaleAdaptive : value;

  @override
  Future<void> ensureInitialized() => ScreenUtil.ensureScreenSize();

  static double _clamp(double scale) => scale
      .clamp(ResponsiveScaler.minScaleFactor, ResponsiveScaler.maxScaleFactor)
      .toDouble();
}

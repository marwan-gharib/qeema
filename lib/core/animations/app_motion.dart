import 'package:flutter/material.dart';

class AppMotion {
  AppMotion._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration heroDelay = Duration(milliseconds: 1000);
  static const Duration heroPulse = Duration(milliseconds: 1500);
  static const Duration hero = Duration(milliseconds: 2000);
  static const Duration heroSlow = Duration(milliseconds: 3000);
  static const Duration heroSequence = Duration(milliseconds: 4000);
  static const Duration splashSequence = Duration(milliseconds: 5000);
  static const Duration staggerStep = Duration(milliseconds: 60);
  static const Duration maxStaggerTotal = Duration(milliseconds: 1200);

  static const Curve entrance = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeOutBack;
  static const Curve standard = Curves.easeInOut;
}

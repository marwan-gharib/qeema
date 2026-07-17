import 'package:flutter/material.dart';

class AppMotion {
  AppMotion._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration staggerStep = Duration(milliseconds: 60);
  static const Duration maxStaggerTotal = Duration(milliseconds: 1200);

  static const Curve entrance = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeOutBack;
  static const Curve standard = Curves.easeInOut;
}

import 'package:flutter/material.dart';

class Responsive {
  static double getFontSize(double screenWidth, double baseSize) {
    if (screenWidth < 400) return baseSize * 0.8;
    if (screenWidth < 600) return baseSize * 0.9;
    return baseSize;
  }

  static EdgeInsets getPadding(double screenWidth) {
    return EdgeInsets.symmetric(
      horizontal: screenWidth < 600 ? 16 : 24,
      vertical: screenWidth < 600 ? 8 : 16,
    );
  }
}
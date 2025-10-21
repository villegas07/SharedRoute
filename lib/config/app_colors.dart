import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF7C4DFF);

  // Secondary colors
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryLight = Color(0xFF34D399);

  // Text colors
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textGrey = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFF95A5A6);
  static const Color textDisabled = Color(0xFFBDC3C7);

  // Background colors
  static const Color background = Color(0xFFF5F6FA);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFFE8EAF6);

  // UI colors
  static const Color white = Colors.white;
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color success = Color(0xFF4CAF50);
  static const Color info = Color(0xFF2196F3);

  // Status colors
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color shadowColor = Colors.black12;

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7C4DFF),
      Color(0xFF536DFE),
      Color(0xFFFF4081),
    ],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
  );
}

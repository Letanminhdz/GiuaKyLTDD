import 'package:flutter/material.dart';

class AppColors {
  // Primary brand palette from Figma prototype
  static const Color primary = Color(0xFF5A4FCF);
  static const Color primaryDark = Color(0xFF473CBA);
  static const Color primarySoft = Color(0xFFF0EFFF);
  static const Color primaryAccent = Color(0xFF7369E8);

  // Neutral typography & surfaces
  static const Color ink = Color(0xFF17213A);
  static const Color muted = Color(0xFF6F7890);
  static const Color line = Color(0xFFE6E8EF);
  static const Color background = Color(0xFFF6F7FB);
  static const Color surface = Color(0xFFFFFFFF);

  // Functional colors
  static const Color success = Color(0xFF168866);
  static const Color successSoft = Color(0xFFEAF8F3);
  static const Color danger = Color(0xFFDF4F58);
  static const Color dangerSoft = Color(0xFFFFF1F2);
  static const Color warning = Color(0xFFE29A2D);
  static const Color warningSoft = Color(0xFFFFF5E5);

  // Subject colors from Figma
  static const Color violetBadge = Color(0xFF6257CF);
  static const Color violetBadgeSoft = Color(0xFFEFEDFF);
  static const Color blueBadge = Color(0xFF4382C5);
  static const Color blueBadgeSoft = Color(0xFFE9F4FF);
  static const Color amberBadge = Color(0xFFC17A16);
  static const Color amberBadgeSoft = Color(0xFFFFF3DF);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.primaryDark,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
        error: AppColors.danger,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}


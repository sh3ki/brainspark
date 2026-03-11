import 'package:flutter/material.dart';

class AppTheme {
  // BrainSpark — Midnight Scholar Palette
  static const Color primary = Color(0xFF1E293B);
  static const Color accent = Color(0xFFF59E0B);
  static const Color secondary = Color(0xFF3B82F6);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color divider = Color(0xFFE2E8F0);

  static BoxShadow get cardShadow => BoxShadow(
        color: const Color(0xFF0F172A).withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      );

  static const List<Color> deckColors = [
    Color(0xFF6366F1),
    Color(0xFF0EA5E9),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFFF97316),
  ];

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: secondary,
        surface: surface,
      ),
    );
    return base.copyWith(
      scaffoldBackgroundColor: surface,
      textTheme: base.textTheme.copyWith(
        displayLarge: const TextStyle(
            fontSize: 56, fontWeight: FontWeight.w900, color: textPrimary),
        headlineLarge: const TextStyle(
            fontSize: 28, fontWeight: FontWeight.w800, color: textPrimary),
        headlineMedium: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary),
        titleLarge: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
        titleMedium: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: textPrimary),
        bodyMedium: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w400, color: textSecondary),
        labelLarge: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          textStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
    );
  }
}

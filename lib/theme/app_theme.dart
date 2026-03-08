import 'package:flutter/material.dart';

class AppTheme {
  // BrainSpark Brand Colors — Electric Purple & Cyan
  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF7C3AED);
  static const Color secondary = Color(0xFF06B6D4);
  static const Color accent = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color surface = Color(0xFFF5F3FF);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E1B4B);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color divider = Color(0xFFEDE9FE);

  static BoxShadow get cardShadow => BoxShadow(
        color: const Color(0xFF8B5CF6).withOpacity(0.10),
        blurRadius: 16,
        offset: const Offset(0, 4),
      );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<Color> deckColors = [
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFFEC4899),
    Color(0xFF3B82F6),
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
        displayLarge: TextStyle(
            fontSize: 56, fontWeight: FontWeight.w900, color: textPrimary),
        headlineLarge: TextStyle(
            fontSize: 28, fontWeight: FontWeight.w800, color: textPrimary),
        headlineMedium: TextStyle(
            fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary),
        titleLarge: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
        titleMedium: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: textPrimary),
        bodyMedium: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w400, color: textSecondary),
        labelLarge: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPrimary),
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          textStyle: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors - Lex Aeterna Tokens
  static const Color primaryGold = Color(0xFFEABF8D);
  static const Color primaryNavy = Color(0xFF121414);
  static const Color surfaceContainer = Color(0xFF1E2020);
  static const Color surfaceContainerLow = Color(0xFF161818);
  static const Color textLight = Color(0xFFE2E2E2);
  static const Color textMuted = Color(0xFFC6C6CD);
  static const Color outlineVariant = Color(0xFF45464D);
  static const Color errorRed = Color(0xFFFFB4AB);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryNavy,
      primaryColor: primaryGold,
      colorScheme: const ColorScheme.dark(
        primary: primaryGold,
        secondary: primaryGold,
        surface: surfaceContainer,
        background: primaryNavy,
        error: errorRed,
      ),
      dividerColor: outlineVariant,
      cardTheme: const CardTheme(
        color: surfaceContainer,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: outlineVariant, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Playfair Display',
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: textLight,
          height: 1.1,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Playfair Display',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textLight,
          height: 1.3,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Playfair Display',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: primaryGold,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textMuted,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textMuted,
          height: 1.6,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
          color: primaryNavy,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: primaryNavy,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Sharp professional corners
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textLight,
          side: const BorderSide(color: outlineVariant, width: 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: primaryNavy,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: outlineVariant),
          borderRadius: BorderRadius.zero,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryGold),
          borderRadius: BorderRadius.zero,
        ),
        labelStyle: TextStyle(color: textMuted, fontSize: 14),
        hintStyle: TextStyle(color: outlineVariant, fontSize: 14),
      ),
    );
  }
}

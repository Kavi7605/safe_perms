import 'package:flutter/material.dart';

class SafePermsTheme {
  // 1. Define Colors Statically
  static const Color primaryGreen = Color(0xFF00C851);
  static const Color greenDark = Color(0xFF007E33);
  static const Color dangerRed = Color(0xFFFF4444);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFF1E1E1E); // Dark Grey

  // 2. Define Theme Getter
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: surfaceDark,
    primaryColor: primaryGreen,

    // Define ColorScheme
    colorScheme: const ColorScheme.dark(
      primary: primaryGreen,
      secondary: greenDark,
      surface: surfaceDark,
      error: dangerRed,
      onSurface: Colors.white,
    ),

    // Card Styling (FIXED: Changed CardTheme to CardThemeData)
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Input Styling
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      labelStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryGreen)),
    ),

    // Text Styling
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
    ),
  );
}
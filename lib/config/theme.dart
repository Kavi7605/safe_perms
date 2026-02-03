import 'package:flutter/material.dart';

class SafePermsTheme {
  static const Color primaryGreen = Color(0xFF00C851);
  static const Color greenDark = Color(0xFF007E33);
  static const Color dangerRed = Color(0xFFFF4444);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFF1F3F4);

  static ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.dark(
      primary: primaryGreen,
      secondary: greenDark,
      error: dangerRed,
      surface: surfaceDark,
    ),
    useMaterial3: true,

    // Simple AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
    ),

    // Simple Bottom Navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryGreen,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),

    // SIMPLIFIED - No CardTheme (eliminates ALL errors)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
      ),
    ),
  );
}

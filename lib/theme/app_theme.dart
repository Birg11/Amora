// ✅ app_theme.dart — Light & Dark Theme
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFAF7F5),
    textTheme: GoogleFonts.poppinsTextTheme(),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFEC4899),
      primary: const Color(0xFFEC4899),
      secondary: const Color(0xFF9333EA),
      surface: Colors.white,
    ),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: const Color(0xFFEC4899),
      primary: const Color(0xFFEC4899),
      secondary: const Color(0xFF9333EA),
      surface: const Color(0xFF1E1E1E),
    ),
    useMaterial3: true,
  );
}

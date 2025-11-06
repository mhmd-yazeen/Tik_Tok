import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryNeon = Color(0xFF00FFDD); // Cyan Neon
  static const Color secondaryNeon = Color(0xFFFF0099); // Pink Neon
  static const Color bgDark = Color(0xFF050B18); // Deep Space Blue
  static const Color bgLight = Color(0xFF1A1F38); // Lighter Navy

  static TextStyle get neonFont => GoogleFonts.orbitron();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: primaryNeon,
      colorScheme: const ColorScheme.dark(
        primary: primaryNeon,
        secondary: secondaryNeon,
        surface: bgLight,
      ),
      textTheme: TextTheme(
        displayLarge: neonFont.copyWith(
            fontSize: 32, fontWeight: FontWeight.bold, color: primaryNeon, shadows: _neonShadow(primaryNeon)),
        bodyLarge: neonFont.copyWith(color: Colors.white),
        bodyMedium: neonFont.copyWith(color: Colors.white70),
      ),
    );
  }

  static List<BoxShadow> _neonShadow(Color color) {
    return [
      BoxShadow(color: color.withOpacity(0.6), blurRadius: 20, spreadRadius: 2),
      BoxShadow(color: color.withOpacity(0.3), blurRadius: 40, spreadRadius: 10),
    ];
  }

  static BoxDecoration neonBox(Color color, {bool isBorderOnly = false}) {
    return BoxDecoration(
      color: isBorderOnly ? Colors.transparent : bgLight,
      border: Border.all(color: color, width: 2),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: color.withOpacity(0.4), blurRadius: 15, spreadRadius: 1),
      ],
    );
  }
}
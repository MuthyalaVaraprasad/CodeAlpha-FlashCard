import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Pure Purple Custom Color Palette constants
  static const Color primaryColor = Color(0xFF6F35A5);
  static const Color primaryGradientStart = Color(0xFF6A1B9A);
  static const Color primaryGradientEnd = Color(0xFF9C27B0);
  
  static const Color lightBgColor = Color(0xFFF8F9FE);
  static const Color lightSurfaceColor = Colors.white;
  static const Color lightTextColor = Color(0xFF2D3142);
  static const Color lightSecondaryTextColor = Color(0xFF9094A6);

  static const Color darkBgColor = Color(0xFF0F0E17);
  static const Color darkSurfaceColor = Color(0xFF242235);
  static const Color darkTextColor = Color(0xFFFFFFFE);
  static const Color darkSecondaryTextColor = Color(0xFFA7A9BE);

  // Gradient styles
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBgColor,
      cardTheme: CardTheme(
        color: lightSurfaceColor,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: Color(0xFFF1E6FF),
        background: lightBgColor,
        surface: lightSurfaceColor,
        onPrimary: Colors.white,
        onBackground: lightTextColor,
        onSurface: lightTextColor,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: lightTextColor),
        titleLarge: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600, color: lightTextColor),
        bodyLarge: GoogleFonts.outfit(fontSize: 16, color: lightTextColor),
        bodyMedium: GoogleFonts.outfit(fontSize: 14, color: lightSecondaryTextColor),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: lightTextColor),
        centerTitle: true,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBgColor,
      cardTheme: CardTheme(
        color: darkSurfaceColor,
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: Color(0xFF2C2540),
        background: darkBgColor,
        surface: darkSurfaceColor,
        onPrimary: Colors.white,
        onBackground: darkTextColor,
        onSurface: darkTextColor,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: darkTextColor),
        titleLarge: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600, color: darkTextColor),
        bodyLarge: GoogleFonts.outfit(fontSize: 16, color: darkTextColor),
        bodyMedium: GoogleFonts.outfit(fontSize: 14, color: darkSecondaryTextColor),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextColor),
        centerTitle: true,
      ),
    );
  }
}

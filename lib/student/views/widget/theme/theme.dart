import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors inspired by FinPay / iBank UI kit (blue-teal)
  static const Color primary = Color(0xFF007E7F); // teal-ish
  static const Color primaryDark = Color(0xFF005A5B);
  static const Color accent = Color(0xFF00C2B3);
  static const Color bg = Color(0xFFF5F7FA);
  static const Color card = Colors.white;

  static final TextTheme textTheme = TextTheme(
    headlineLarge: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.black87),
    titleLarge: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
    bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
    bodyMedium: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
    labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
  );

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accent, primary: primary),
    cardColor: card,
    textTheme: textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      elevation: 12,
      backgroundColor: card,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: textTheme.labelLarge,
        elevation: 8,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    ),
  );
}

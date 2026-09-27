import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const border = Color(0xFFE2E8F0);
  static const borderStrong = Color(0xFFCBD5E1);
  static const ink = Color(0xFF0F172A);
  static const inkSoft = Color(0xFF475569);
  static const inkFaint = Color(0xFF94A3B8);
  static const inkFaintest = Color(0xFFCBD5E1);
  static const crimson = Color(0xFFDC2626);
  static const crimsonSoft = Color(0xFFFEF2F2);
  static const emerald = Color(0xFF16A34A);
  static const emeraldSoft = Color(0xFFF0FDF4);
  static const emeraldBorder = Color(0xFFBBF7D0);
  static const amber = Color(0xFFD97706);
  static const amberSoft = Color(0xFFFFFBEB);
  static const amberBorder = Color(0xFFFDE68A);
}

class AppText {
  static TextStyle mono({
    double size = 12,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double? ls,
    double? height,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: ls,
        height: height,
      );

  static TextStyle serif({
    double size = 18,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.ink,
    double? ls,
    double? height,
    bool italic = false,
  }) =>
      GoogleFonts.fraunces(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: ls,
        height: height,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      );

  static TextStyle sans({
    double size = 13,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double? ls,
    double? height,
    bool italic = false,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: ls,
        height: height,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      );
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.crimson),
        textTheme: GoogleFonts.interTextTheme(),
      );
}
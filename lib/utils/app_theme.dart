import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static const primary = Color(0xFF7047F8);
  static const secondary = Color(0xFF182443);
  static const background = Color(0xFFF8F9FC);
  static const surfaceTint = Color(0xFFF1EDFF);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary).copyWith(
      primary: primary,
      onPrimary: Colors.white,
      tertiary: const Color(0xFF9478FF),
      secondary: secondary,
      onSecondary: Colors.white,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: secondary,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFE2E5EF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFE2E5EF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: primary, width: 1.6),
      ),
    ),
  );

  static Color statusColor(String status) {
    switch (status) {
      case IncidentStatus.inReview:
        return const Color(0xFF0EA5E9);
      case IncidentStatus.inProgress:
        return const Color(0xFF2563EB);
      case IncidentStatus.resolved:
        return const Color(0xFF16A34A);
      default:
        return const Color(0xFFF59E0B);
    }
  }
}

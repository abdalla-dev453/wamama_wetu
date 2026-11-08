import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const TextTheme displayLarge = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, color: Color(0xFF1A1C1B)),
  );

  static const TextTheme headlineMedium = TextTheme(
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3, color: Color(0xFF1A1C1B)),
  );

  static const TextTheme titleLarge = TextTheme(
    titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4, color: Color(0xFF1A1C1B)),
  );

  static const TextTheme bodyLarge = TextTheme(
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: Color(0xFF1A1C1B)),
  );

  static const TextTheme bodyMedium = TextTheme(
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: Color(0xFF5C615F)),
  );

  static const TextTheme labelLarge = TextTheme(
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4, color: Color(0xFF1A1C1B)),
  );
}
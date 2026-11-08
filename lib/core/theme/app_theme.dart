import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainerHighest: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    error: AppColors.error,
  );

  static final ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: AppColors.primaryContainer,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primary,
    secondary: AppColors.secondaryContainer,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondary,
    surface: const Color(0xFF121413),
    onSurface: const Color(0xFFE4E6E5),
    surfaceContainerHighest: const Color(0xFF232524),
    onSurfaceVariant: const Color(0xFFB9BFC0),
    outline: const Color(0xFF5C615F),
    error: AppColors.error,
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _lightColorScheme,
    scaffoldBackgroundColor: AppColors.background,
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.surfaceVariant,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, color: Color(0xFF1A1C1B)),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.2, color: Color(0xFF1A1C1B)),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.25, color: Color(0xFF1A1C1B)),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3, color: Color(0xFF1A1C1B)),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3, color: Color(0xFF1A1C1B)),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4, color: Color(0xFF1A1C1B)),
      titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.4, color: Color(0xFF1A1C1B)),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4, color: Color(0xFF1A1C1B)),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: Color(0xFF1A1C1B)),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: Color(0xFF5C615F)),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5, color: Color(0xFF8A8F8D)),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4, color: Color(0xFF1A1C1B)),
    ),
  );

static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _darkColorScheme,
    scaffoldBackgroundColor: const Color(0xFF121413),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2A2C2B),
      thickness: 1,
      indent: 16,
      endIndent: 16,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, color: Color(0xFFFFFFFF)),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.2, color: Color(0xFFFFFFFF)),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.25, color: Color(0xFFFFFFFF)),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3, color: Color(0xFFFFFFFF)),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3, color: Color(0xFFFFFFFF)),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4, color: Color(0xFFFFFFFF)),
      titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.4, color: Color(0xFFFFFFFF)),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4, color: Color(0xFFFFFFFF)),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: Color(0xFFE4E6E5)),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: Color(0xFFB9BFC0)),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5, color: Color(0xFF8A8F8D)),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4, color: Color(0xFFFFFFFF)),
    ),
  );
}
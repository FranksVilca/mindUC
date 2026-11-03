import 'package:flutter/material.dart';
import 'mind_colors.dart';
import 'mind_radii.dart';
import 'mind_typography.dart';

/// Configuración de ThemeData para mindUC en Material 3.
abstract final class MindTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: MindColors.background,
      colorScheme: const ColorScheme.light(
        primary: MindColors.primary,
        onPrimary: MindColors.onPrimary,
        secondary: MindColors.autocuidadoAccent,
        surface: MindColors.surface,
        onSurface: MindColors.textPrimary,
        error: MindColors.error,
        onError: Colors.white,
      ),
      dividerColor: MindColors.divider,
      cardTheme: const CardThemeData(
        color: MindColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: MindRadii.cardRadius),
      ),
      textTheme: TextTheme(
        displayLarge: MindTypography.displayLarge,
        titleLarge: MindTypography.titleLarge,
        titleMedium: MindTypography.titleMedium,
        bodyLarge: MindTypography.bodyLarge,
        bodyMedium: MindTypography.bodyMedium,
        labelLarge: MindTypography.labelLarge,
        labelSmall: MindTypography.labelSmall,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: MindColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: MindColors.textPrimary),
        titleTextStyle: MindTypography.titleMedium,
      ),
    );
  }
}


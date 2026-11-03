import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mind_colors.dart';

/// Escala tipográfica oficial de mindUC basada en Plus Jakarta Sans.
abstract final class MindTypography {
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: MindColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: MindColors.textPrimary,
        letterSpacing: -0.2,
      );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: MindColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: MindColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: MindColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: MindColors.textPrimary,
      );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: MindColors.textTertiary,
      );
}


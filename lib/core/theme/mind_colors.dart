import 'package:flutter/material.dart';

/// Tokens de color oficiales de mindUC extraídos de los 12 mockups de Figma.
abstract final class MindColors {
  // Fondos y superficies
  static const Color background = Color(0xFFFBF9F4); // Crema sereno suave
  static const Color surface = Color(0xFFFFFFFF); // Blanco puro para tarjetas
  static const Color surfaceSubtle = Color(0xFFF4EFE6);

  // Marca y color primario
  static const Color primary = Color(0xFF718E81); // Verde salvia suave
  static const Color primaryDark = Color(0xFF4C6B5E);
  static const Color primaryLight = Color(0xFFA6BCB2);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Categorías de bienestar (Figma)
  static const Color autocuidado = Color(0xFFEAF1ED);
  static const Color autocuidadoAccent = Color(0xFF5D8572);

  static const Color estudioTrabajo = Color(0xFFEBE8F7);
  static const Color estudioTrabajoAccent = Color(0xFF7B72B8);

  static const Color saludMental = Color(0xFFFCE7E1);
  static const Color saludMentalAccent = Color(0xFFD67868);

  static const Color descanso = Color(0xFFE5F0F5);
  static const Color descansoAccent = Color(0xFF5B8A99);

  // Textos y divisores serenos
  static const Color textPrimary = Color(0xFF222E28); // Gris carbón suave
  static const Color textSecondary = Color(0xFF5C6B64); // Gris neutro medio
  static const Color textTertiary = Color(0xFF8F9E96); // Gris claro / meta
  static const Color divider = Color(0xFFEDE9DF);

  // Estados semánticos
  static const Color success = Color(0xFF5D8572);
  static const Color warning = Color(0xFFE5A93C);
  static const Color error = Color(0xFFD66853);
}

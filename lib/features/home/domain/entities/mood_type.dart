import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Los cinco estados anímicos conscientes capturados en el diseño oficial de Figma.
enum MoodType {
  calma,
  feliz,
  ansiosa,
  cansada,
  energica;

  String get label {
    switch (this) {
      case MoodType.calma:
        return 'Calma';
      case MoodType.feliz:
        return 'Feliz';
      case MoodType.ansiosa:
        return 'Ansiosa';
      case MoodType.cansada:
        return 'Cansada';
      case MoodType.energica:
        return 'Enérgica';
    }
  }

  String get emoji {
    switch (this) {
      case MoodType.calma:
        return '😌';
      case MoodType.feliz:
        return '✨';
      case MoodType.ansiosa:
        return '🌧️';
      case MoodType.cansada:
        return '☕';
      case MoodType.energica:
        return '🌱';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case MoodType.calma:
        return MindColors.autocuidado;
      case MoodType.feliz:
        return MindColors.saludMental;
      case MoodType.ansiosa:
        return MindColors.productividad;
      case MoodType.cansada:
        return MindColors.accentCalm;
      case MoodType.energica:
        return MindColors.bienestarPill;
    }
  }

  static MoodType fromString(String? value) {
    if (value == null) return MoodType.calma;
    switch (value.toLowerCase()) {
      case 'calma':
        return MoodType.calma;
      case 'feliz':
        return MoodType.feliz;
      case 'ansiosa':
        return MoodType.ansiosa;
      case 'cansada':
        return MoodType.cansada;
      case 'energica':
      case 'enérgica':
        return MoodType.energica;
      default:
        return MoodType.calma;
    }
  }
}

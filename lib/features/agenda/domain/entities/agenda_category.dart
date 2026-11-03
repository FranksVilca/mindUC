import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';

/// Categorías de bienestar y balance consciente de la agenda.
enum AgendaCategory {
  autocuidado(
    displayName: 'Autocuidado',
    chipLabel: 'Autocuidado',
    backgroundColor: MindColors.autocuidado,
    accentColor: MindColors.autocuidadoAccent,
  ),
  estudioTrabajo(
    displayName: 'Estudio / Trabajo',
    chipLabel: 'Trabajo',
    backgroundColor: MindColors.estudioTrabajo,
    accentColor: MindColors.estudioTrabajoAccent,
  ),
  saludMental(
    displayName: 'Salud mental',
    chipLabel: 'Salud mental',
    backgroundColor: MindColors.saludMental,
    accentColor: MindColors.saludMentalAccent,
  );

  final String displayName;
  final String chipLabel;
  final Color backgroundColor;
  final Color accentColor;

  const AgendaCategory({
    required this.displayName,
    required this.chipLabel,
    required this.backgroundColor,
    required this.accentColor,
  });

  /// Encuentra la categoría a partir de un nombre o etiqueta
  static AgendaCategory fromString(String value) {
    for (final cat in AgendaCategory.values) {
      if (cat.name.toLowerCase() == value.toLowerCase() ||
          cat.displayName.toLowerCase() == value.toLowerCase() ||
          cat.chipLabel.toLowerCase() == value.toLowerCase()) {
        return cat;
      }
    }
    return AgendaCategory.autocuidado;
  }
}


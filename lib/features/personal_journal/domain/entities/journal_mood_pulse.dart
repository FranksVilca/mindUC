/// Estados de pulso afectivo y emocional disponibles en el Diario Personal.
enum JournalMoodPulse {
  agradecida,
  enCalma,
  reflexiva,
  cansada,
  abrumada;

  /// Etiqueta simple para selectores y botones.
  String get label {
    switch (this) {
      case JournalMoodPulse.agradecida:
        return 'Agradecida';
      case JournalMoodPulse.enCalma:
        return 'En calma';
      case JournalMoodPulse.reflexiva:
        return 'Reflexiva';
      case JournalMoodPulse.cansada:
        return 'Cansada';
      case JournalMoodPulse.abrumada:
        return 'Abrumada';
    }
  }

  /// Texto con emoji de identidad para las tarjetas de huellas interiores.
  String get chipText {
    switch (this) {
      case JournalMoodPulse.agradecida:
        return '✨ Agradecida';
      case JournalMoodPulse.enCalma:
        return '🌸 En calma';
      case JournalMoodPulse.reflexiva:
        return '🌿 Reflexiva';
      case JournalMoodPulse.cansada:
        return '☁️ Cansada';
      case JournalMoodPulse.abrumada:
        return '🌊 Abrumada';
    }
  }

  /// Identificador semántico del icono correspondiente.
  String get iconName {
    switch (this) {
      case JournalMoodPulse.agradecida:
        return 'auto_awesome';
      case JournalMoodPulse.enCalma:
        return 'local_florist';
      case JournalMoodPulse.reflexiva:
        return 'eco';
      case JournalMoodPulse.cansada:
        return 'cloud';
      case JournalMoodPulse.abrumada:
        return 'waves';
    }
  }
}


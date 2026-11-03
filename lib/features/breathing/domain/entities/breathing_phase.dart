/// Fases del ciclo biomecánico de respiración consciente.
enum BreathingPhase {
  inhale,
  hold,
  exhale,
  rest;

  /// Instrucción principal para la fase activa.
  String get instruction {
    switch (this) {
      case BreathingPhase.inhale:
        return 'Inhala suave';
      case BreathingPhase.hold:
        return 'Retén el aire';
      case BreathingPhase.exhale:
        return 'Exhala despacio';
      case BreathingPhase.rest:
        return 'Pausa en calma';
    }
  }

  /// Guía biomecánica corporal mostrada en mayúsculas espaciadas según Figma.
  String get biomechanicalHint {
    switch (this) {
      case BreathingPhase.inhale:
        return 'EXPANDE EL ABDOMEN';
      case BreathingPhase.hold:
        return 'MANTÉN LA CALMA';
      case BreathingPhase.exhale:
        return 'LIBERA LA TENSIÓN';
      case BreathingPhase.rest:
        return 'DESCANSA EL CUERPO';
    }
  }
}

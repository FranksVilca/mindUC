/// Entidad inmutable que representa una técnica de respiración consciente.
class BreathingTechnique {
  final String id;
  final String name;
  final String description;
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final int postHoldSeconds;

  const BreathingTechnique({
    required this.id,
    required this.name,
    required this.description,
    required this.inhaleSeconds,
    this.holdSeconds = 0,
    required this.exhaleSeconds,
    this.postHoldSeconds = 0,
  });

  int get cycleDurationSeconds =>
      inhaleSeconds + holdSeconds + exhaleSeconds + postHoldSeconds;

  static const BreathingTechnique box444 = BreathingTechnique(
    id: 'box_444',
    name: 'Respiración 4-4-4 (Caja)',
    description: 'Enfoca la mente y reduce la agitación antes de estudiar.',
    inhaleSeconds: 4,
    holdSeconds: 4,
    exhaleSeconds: 4,
    postHoldSeconds: 0,
  );

  static const BreathingTechnique relaxing478 = BreathingTechnique(
    id: 'relaxing_478',
    name: 'Respiración 4-7-8 (Relajante)',
    description: 'Activa el sistema parasimpático para disipar la ansiedad.',
    inhaleSeconds: 4,
    holdSeconds: 7,
    exhaleSeconds: 8,
    postHoldSeconds: 0,
  );

  static const BreathingTechnique serene87 = BreathingTechnique(
    id: 'serene_87',
    name: 'Respiración Serena 8-7',
    description: 'Ritmo suave de desconexión y pausa serena.',
    inhaleSeconds: 8,
    holdSeconds: 0,
    exhaleSeconds: 7,
    postHoldSeconds: 0,
  );

  static const List<BreathingTechnique> presets = [
    box444,
    relaxing478,
    serene87,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreathingTechnique &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

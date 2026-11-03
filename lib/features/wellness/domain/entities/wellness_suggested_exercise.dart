/// Entidad inmutable que modela el ejercicio de bienestar sugerido del día.
class WellnessSuggestedExercise {
  final String id;
  final String categoryLabel;
  final String title;
  final String description;
  final String techniqueId;
  final int durationSeconds;
  final String statusLabel;
  final String actionLabel;

  const WellnessSuggestedExercise({
    required this.id,
    required this.categoryLabel,
    required this.title,
    required this.description,
    required this.techniqueId,
    required this.durationSeconds,
    required this.statusLabel,
    required this.actionLabel,
  });

  /// Ejercicio sugerido oficial según mockup de Figma (`mindUC - Bienestar.png`).
  static const defaultDaily = WellnessSuggestedExercise(
    id: 'suggested_breath_478',
    categoryLabel: 'EJERCICIO SUGERIDO PARA TI HOY',
    title: 'Respiración 4–7–8',
    description: 'Técnica antiestrés recomendada para despejar la sobrecarga',
    techniqueId: 'relaxing_478',
    durationSeconds: 300,
    statusLabel: 'Ciclo guiado',
    actionLabel: 'Comenzar (5 min)',
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WellnessSuggestedExercise &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Tipos de iconos compasivos para las intenciones semanales.
enum IntentionIconType {
  pauses, // Pausas activas (Checkmark / descanso)
  walk, // Paseo consciente (Reloj de arena / pasos)
  screens, // Desconexión de pantallas (Luna / sueño)
}

/// Entidad inmutable que representa una meta amable semanal (Principio III: Metas sin prisa).
class WeeklyIntention {
  final String id;
  final String title;
  final int currentUnits;
  final int targetUnits;
  final String unitLabel;
  final bool isCompleted;
  final IntentionIconType iconType;

  const WeeklyIntention({
    required this.id,
    required this.title,
    required this.currentUnits,
    required this.targetUnits,
    required this.unitLabel,
    required this.isCompleted,
    required this.iconType,
  });

  double get progressRatio =>
      targetUnits > 0 ? (currentUnits / targetUnits).clamp(0.0, 1.0) : 0.0;

  WeeklyIntention copyWith({
    String? id,
    String? title,
    int? currentUnits,
    int? targetUnits,
    String? unitLabel,
    bool? isCompleted,
    IntentionIconType? iconType,
  }) {
    return WeeklyIntention(
      id: id ?? this.id,
      title: title ?? this.title,
      currentUnits: currentUnits ?? this.currentUnits,
      targetUnits: targetUnits ?? this.targetUnits,
      unitLabel: unitLabel ?? this.unitLabel,
      isCompleted: isCompleted ?? this.isCompleted,
      iconType: iconType ?? this.iconType,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyIntention &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          currentUnits == other.currentUnits &&
          targetUnits == other.targetUnits &&
          unitLabel == other.unitLabel &&
          isCompleted == other.isCompleted &&
          iconType == other.iconType;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      currentUnits.hashCode ^
      targetUnits.hashCode ^
      unitLabel.hashCode ^
      isCompleted.hashCode ^
      iconType.hashCode;
}


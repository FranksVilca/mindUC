/// Tipos de representación visual y animación corporal para cada paso de relajación.
enum RelaxationVisualType {
  neckRight,
  neckHold,
  neckCenter,
  neckLeft,
  neckMobility,
  backSit,
  backReach,
  backFold,
  backExtend,
  backRelax,
  jawRelax,
  jawLocate,
  jawCircles,
  jawGlide,
  jawRelease,
  eyeLookAway,
  eyeFocusDistance,
  eyeBlink,
  eyePalming,
  eyeInfinity,
}

/// Entidad inmutable que modela un paso individual dentro de una rutina de relajación o pausa activa.
class RelaxationStep {
  final int stepNumber;
  final String title;
  final String instruction;
  final String ergonomicTip;
  final int durationSeconds;
  final String bodyPartFocus;
  final String movementDirection;
  final RelaxationVisualType visualType;

  const RelaxationStep({
    required this.stepNumber,
    required this.title,
    required this.instruction,
    required this.ergonomicTip,
    required this.durationSeconds,
    required this.bodyPartFocus,
    required this.movementDirection,
    required this.visualType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelaxationStep &&
          runtimeType == other.runtimeType &&
          stepNumber == other.stepNumber &&
          title == other.title;

  @override
  int get hashCode => stepNumber.hashCode ^ title.hashCode;
}

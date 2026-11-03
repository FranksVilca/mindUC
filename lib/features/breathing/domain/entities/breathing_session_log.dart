/// Entidad inmutable que representa el registro histórico de una sesión de respiración.
class BreathingSessionLog {
  final String id;
  final String userId;
  final String techniqueId;
  final int durationSeconds;
  final int cyclesCompleted;
  final String dateString;
  final int timestampMillis;

  const BreathingSessionLog({
    required this.id,
    required this.userId,
    required this.techniqueId,
    required this.durationSeconds,
    required this.cyclesCompleted,
    required this.dateString,
    required this.timestampMillis,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreathingSessionLog &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

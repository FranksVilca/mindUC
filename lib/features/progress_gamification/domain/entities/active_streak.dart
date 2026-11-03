/// Value Object inmutable que modela la racha de autocuidado activo del estudiante.
/// Diseñado bajo el Principio III: gamificación compasiva sin penalizaciones ni culpa.
class ActiveStreak {
  final int daysCount;
  final String message;
  final List<bool> completedDays; // Longitud 7: [L, M, X, J, V, S, D]
  final int currentDayIndex; // 0..6

  const ActiveStreak({
    required this.daysCount,
    required this.message,
    required this.completedDays,
    required this.currentDayIndex,
  });

  bool isDayCompleted(int index) =>
      index >= 0 && index < completedDays.length ? completedDays[index] : false;

  ActiveStreak copyWith({
    int? daysCount,
    String? message,
    List<bool>? completedDays,
    int? currentDayIndex,
  }) {
    return ActiveStreak(
      daysCount: daysCount ?? this.daysCount,
      message: message ?? this.message,
      completedDays: completedDays ?? this.completedDays,
      currentDayIndex: currentDayIndex ?? this.currentDayIndex,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActiveStreak &&
          runtimeType == other.runtimeType &&
          daysCount == other.daysCount &&
          message == other.message &&
          currentDayIndex == other.currentDayIndex;

  @override
  int get hashCode =>
      daysCount.hashCode ^ message.hashCode ^ currentDayIndex.hashCode;
}


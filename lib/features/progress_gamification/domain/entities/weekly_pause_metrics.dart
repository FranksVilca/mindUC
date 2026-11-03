/// Value Object inmutable que resume los momentos de pausa semanales de bienestar.
class WeeklyPauseMetrics {
  final int breathingMinutes;
  final int pomodoroSessions;
  final int journalEntriesCount;
  final int balancePercentage;

  const WeeklyPauseMetrics({
    required this.breathingMinutes,
    required this.pomodoroSessions,
    required this.journalEntriesCount,
    required this.balancePercentage,
  });

  WeeklyPauseMetrics copyWith({
    int? breathingMinutes,
    int? pomodoroSessions,
    int? journalEntriesCount,
    int? balancePercentage,
  }) {
    return WeeklyPauseMetrics(
      breathingMinutes: breathingMinutes ?? this.breathingMinutes,
      pomodoroSessions: pomodoroSessions ?? this.pomodoroSessions,
      journalEntriesCount: journalEntriesCount ?? this.journalEntriesCount,
      balancePercentage: balancePercentage ?? this.balancePercentage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyPauseMetrics &&
          runtimeType == other.runtimeType &&
          breathingMinutes == other.breathingMinutes &&
          pomodoroSessions == other.pomodoroSessions &&
          journalEntriesCount == other.journalEntriesCount &&
          balancePercentage == other.balancePercentage;

  @override
  int get hashCode =>
      breathingMinutes.hashCode ^
      pomodoroSessions.hashCode ^
      journalEntriesCount.hashCode ^
      balancePercentage.hashCode;
}


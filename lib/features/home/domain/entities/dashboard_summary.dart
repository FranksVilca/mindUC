import 'mood_type.dart';

/// Entidad inmutable que consolida las métricas del dashboard de inicio.
class DashboardSummary {
  final String greetingName;
  final String formattedDate;
  final MoodType? todayMood;
  final int pendingActivitiesCount;
  final int streakDays;

  const DashboardSummary({
    required this.greetingName,
    required this.formattedDate,
    this.todayMood,
    this.pendingActivitiesCount = 4,
    this.streakDays = 7,
  });

  DashboardSummary copyWith({
    String? greetingName,
    String? formattedDate,
    MoodType? todayMood,
    int? pendingActivitiesCount,
    int? streakDays,
  }) {
    return DashboardSummary(
      greetingName: greetingName ?? this.greetingName,
      formattedDate: formattedDate ?? this.formattedDate,
      todayMood: todayMood ?? this.todayMood,
      pendingActivitiesCount: pendingActivitiesCount ?? this.pendingActivitiesCount,
      streakDays: streakDays ?? this.streakDays,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardSummary &&
          runtimeType == other.runtimeType &&
          greetingName == other.greetingName &&
          formattedDate == other.formattedDate &&
          todayMood == other.todayMood &&
          pendingActivitiesCount == other.pendingActivitiesCount &&
          streakDays == other.streakDays;

  @override
  int get hashCode =>
      greetingName.hashCode ^
      formattedDate.hashCode ^
      todayMood.hashCode ^
      pendingActivitiesCount.hashCode ^
      streakDays.hashCode;
}


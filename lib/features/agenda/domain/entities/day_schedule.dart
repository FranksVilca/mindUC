import 'agenda_activity.dart';

/// Value Object inmutable que resume los compromisos y el equilibrio de un día específico.
class DaySchedule {
  final DateTime date;
  final List<AgendaActivity> activities;

  const DaySchedule({
    required this.date,
    required this.activities,
  });

  int get totalActivities => activities.length;
  int get completedActivities => activities.where((a) => a.isCompleted).length;
  bool get hasActivities => activities.isNotEmpty;

  /// Progreso de balance entre 0.0 y 1.0
  double get balanceProgress =>
      totalActivities > 0 ? (completedActivities / totalActivities) : 0.0;

  /// Número de semana del año según calendario ISO 8601
  int get weekNumber {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;
    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
    final diff = date.difference(firstMonday).inDays;
    return (diff / 7).floor() + 1;
  }
}


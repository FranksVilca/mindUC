import 'agenda_activity.dart';
import 'agenda_category.dart';

/// Estado inmutable consumido por la pantalla y componentes de la Agenda.
class AgendaState {
  final DateTime selectedDate;
  final String selectedFilter;
  final List<AgendaActivity> allActivities;
  final bool isLoading;

  const AgendaState({
    required this.selectedDate,
    this.selectedFilter = 'Todas',
    this.allActivities = const [],
    this.isLoading = false,
  });

  /// Actividades correspondientes únicamente al día seleccionado, ordenadas cronológicamente
  List<AgendaActivity> get activitiesForSelectedDay {
    final list = allActivities.where((a) {
      final s = a.scheduledDateTime;
      return s.year == selectedDate.year &&
          s.month == selectedDate.month &&
          s.day == selectedDate.day;
    }).toList()
      ..sort((a, b) => a.scheduledDateTime.compareTo(b.scheduledDateTime));
    return list;
  }

  /// Actividades del día seleccionado aplicando el filtro de categoría activo
  List<AgendaActivity> get filteredActivities {
    final dayActivities = activitiesForSelectedDay;
    if (selectedFilter == 'Todas') {
      return dayActivities;
    }
    return dayActivities.where((a) {
      switch (selectedFilter) {
        case 'Autocuidado':
          return a.category == AgendaCategory.autocuidado;
        case 'Estudio / Trabajo':
          return a.category == AgendaCategory.estudioTrabajo;
        case 'Salud mental':
          return a.category == AgendaCategory.saludMental;
        default:
          return true;
      }
    }).toList();
  }

  int get totalForDay => activitiesForSelectedDay.length;
  int get completedForDay =>
      activitiesForSelectedDay.where((a) => a.isCompleted).length;

  /// Texto compasivo de balance (ej. '4 actividades · 2 completadas')
  String get rhythmText => '$totalForDay actividades · $completedForDay completadas';

  /// Genera la lista de los 7 días (Lunes a Domingo) para la semana de `selectedDate`
  List<DateTime> get weekDays {
    final weekday = selectedDate.weekday; // 1 (Mon) .. 7 (Sun)
    final monday = selectedDate.subtract(Duration(days: weekday - 1));
    return List.generate(7, (index) {
      final d = monday.add(Duration(days: index));
      return DateTime(d.year, d.month, d.day);
    });
  }

  /// Conteo de actividades para una fecha específica (usado para los puntos de densidad)
  int activitiesCountForDate(DateTime date) {
    return allActivities.where((a) {
      final s = a.scheduledDateTime;
      return s.year == date.year && s.month == date.month && s.day == date.day;
    }).length;
  }

  /// Número de semana del año según calendario ISO 8601
  int get weekNumber {
    final firstDayOfYear = DateTime(selectedDate.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;
    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
    final diff = selectedDate.difference(firstMonday).inDays;
    return (diff / 7).floor() + 1;
  }

  AgendaState copyWith({
    DateTime? selectedDate,
    String? selectedFilter,
    List<AgendaActivity>? allActivities,
    bool? isLoading,
  }) {
    return AgendaState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      allActivities: allActivities ?? this.allActivities,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


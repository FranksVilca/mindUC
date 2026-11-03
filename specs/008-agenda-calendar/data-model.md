# Data Model: 008-agenda-calendar

## Entities & Value Objects (Domain Layer)

### 1. `AgendaCategory` (Enum)
Representa las categorías de bienestar y ritmo consciente disponibles en la agenda.

```dart
enum AgendaCategory {
  autocuidado(
    displayName: 'Autocuidado',
    chipLabel: 'Autocuidado',
  ),
  estudioTrabajo(
    displayName: 'Estudio / Trabajo',
    chipLabel: 'Trabajo',
  ),
  saludMental(
    displayName: 'Salud mental',
    chipLabel: 'Salud mental',
  );

  final String displayName;
  final String chipLabel;

  const AgendaCategory({
    required this.displayName,
    required this.chipLabel,
  });
}
```

### 2. `AgendaActivity` (Domain Entity)
Representa una actividad, hábito o compromiso planificado en un horario específico.

```dart
class AgendaActivity {
  final String id;
  final String title;
  final String subtitle;
  final DateTime scheduledDateTime;
  final AgendaCategory category;
  final bool isCompleted;
  final DateTime createdAt;

  const AgendaActivity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.scheduledDateTime,
    required this.category,
    this.isCompleted = false,
    required this.createdAt,
  });

  /// Hora formateada en formato legible AM/PM (ej. '08:00 AM', '11:30 AM')
  String get formattedTime;

  /// Retorna una copia con campos modificados
  AgendaActivity copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? scheduledDateTime,
    AgendaCategory? category,
    bool? isCompleted,
    DateTime? createdAt,
  });
}
```

### 3. `DaySchedule` (Value Object)
Representa el resumen de una jornada específica de la semana.

```dart
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
  double get balanceProgress => totalActivities > 0 ? (completedActivities / totalActivities) : 0.0;
}
```

### 4. `AgendaState` (Riverpod State Model)
Estado reactivo inmutable consumido por la pantalla `AgendaScreen`.

```dart
class AgendaState {
  final DateTime selectedDate;
  final String selectedFilter; // 'Todas', 'Autocuidado', 'Estudio / Trabajo', 'Salud mental'
  final List<AgendaActivity> allActivities;
  final bool isLoading;

  const AgendaState({
    required this.selectedDate,
    this.selectedFilter = 'Todas',
    this.allActivities = const [],
    this.isLoading = false,
  });

  /// Actividades correspondientes a la fecha seleccionada
  List<AgendaActivity> get activitiesForSelectedDay;

  /// Actividades filtradas según la categoría activa
  List<AgendaActivity> get filteredActivities;

  int get totalForDay => activitiesForSelectedDay.length;
  int get completedForDay => activitiesForSelectedDay.where((a) => a.isCompleted).length;
  String get rhythmText => '$totalForDay actividades · $completedForDay completadas';

  AgendaState copyWith({
    DateTime? selectedDate,
    String? selectedFilter,
    List<AgendaActivity>? allActivities,
    bool? isLoading,
  });
}
```

## Repositories & Data Sources

### `AgendaRepository` (Domain Interface)
```dart
abstract class AgendaRepository {
  Future<List<AgendaActivity>> getActivities();
  Future<void> saveActivity(AgendaActivity activity);
  Future<void> toggleActivityCompletion(String id);
  Future<void> deleteActivity(String id);
}
```

### `LocalAgendaDataSource` (Data Layer)
Almacena las actividades en memoria/local en el dispositivo del estudiante, precargando las 4 actividades iniciales del diseño de Figma para el día jueves 24 de octubre de 2024 (o fecha actual configurable).

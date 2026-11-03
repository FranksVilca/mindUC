# UI Contract: 008-agenda-calendar

## Overview
Contrato de interfaz de usuario y signaturas de controladores para el módulo de Agenda y Calendario Consciente.

## Controller Contract: `IAgendaController`

```dart
abstract class IAgendaController {
  /// Selecciona una fecha específica en la tira semanal o calendario
  void selectDate(DateTime date);

  /// Selecciona el filtro de categoría activo ('Todas', 'Autocuidado', 'Estudio / Trabajo', 'Salud mental')
  void selectFilter(String filter);

  /// Conmuta el estado de completada de una actividad por su ID
  Future<void> toggleActivityCompletion(String id);

  /// Crea una nueva actividad consciente
  Future<void> createActivity({
    required String title,
    required String subtitle,
    required DateTime scheduledDateTime,
    required AgendaCategory category,
  });

  /// Elimina una actividad por su ID
  Future<void> deleteActivity(String id);
}
```

## Presentation Widgets Contract

### 1. `AgendaHeader`
- **Responsabilidad**: Renderiza la cabecera serena de la pestaña de agenda.
- **Parámetros**:
  - `VoidCallback? onNotification`
  - `VoidCallback? onProfile`

### 2. `WeeklyDayStrip`
- **Responsabilidad**: Renderiza la tira horizontal de 7 días (Lunes a Domingo) de la semana seleccionada, mostrando abreviatura, número de día y puntos indicadores de densidad de tareas.
- **Parámetros**:
  - `required DateTime selectedDate`
  - `required List<AgendaActivity> activities`
  - `required ValueChanged<DateTime> onDateSelected`

### 3. `RhythmBalanceCard`
- **Responsabilidad**: Renderiza la tarjeta "Ritmo en equilibrio" con icono circular de bienestar, texto de balance (ej. `4 actividades · 2 completadas`) y enlace `Historial >`.
- **Parámetros**:
  - `required int totalActivities`
  - `required int completedActivities`
  - `VoidCallback? onHistoryTap`

### 4. `CategoryFilterChips`
- **Responsabilidad**: Barra horizontal de chips de filtrado (`Todas`, `Autocuidado`, `Estudio / Trabajo`).
- **Parámetros**:
  - `required String selectedFilter`
  - `required ValueChanged<String> onFilterSelected`

### 5. `ActivityCard`
- **Responsabilidad**: Tarjeta individual de actividad con selector circular interactivo, hora, chip de categoría, título con tachado suave condicional y descripción.
- **Parámetros**:
  - `required AgendaActivity activity`
  - `required VoidCallback onToggleComplete`
  - `VoidCallback? onTap`

### 6. `ActivityCreateModal`
- **Responsabilidad**: Hoja modal para ingresar título, descripción, hora y categoría de una nueva actividad.
- **Método de invocación**:
  ```dart
  static Future<void> show(
    BuildContext context, {
    required DateTime defaultDate,
    required void Function(
      String title,
      String subtitle,
      DateTime scheduledDateTime,
      AgendaCategory category,
    ) onSave,
  });
  ```

import '../../domain/entities/agenda_activity.dart';
import '../../domain/entities/agenda_category.dart';

/// Fuente de datos local en memoria para la agenda consciente (Principio V).
class LocalAgendaDataSource {
  LocalAgendaDataSource({List<AgendaActivity>? initialActivities}) {
    if (initialActivities != null) {
      _activities.addAll(initialActivities);
    } else {
      _activities.addAll(_mockInitialActivities);
    }
  }

  final List<AgendaActivity> _activities = [];

  /// Actividades iniciales de alta fidelidad según el mockup de Figma (24 de Octubre de 2024)
  static List<AgendaActivity> get _mockInitialActivities {
    const targetYear = 2024;
    const targetMonth = 10;
    const targetDay = 24;

    return [
      AgendaActivity(
        id: 'activity-1',
        title: 'Meditación matutina y respiración',
        subtitle: '10 min de enfoque guiado para iniciar el día en calma.',
        scheduledDateTime: DateTime(targetYear, targetMonth, targetDay, 8, 0),
        category: AgendaCategory.autocuidado,
        isCompleted: true,
        createdAt: DateTime(targetYear, targetMonth, targetDay, 7, 0),
      ),
      AgendaActivity(
        id: 'activity-2',
        title: 'Sesión de estudio concentrado (Pomodoro)',
        subtitle: 'Lectura de apuntes y revisión de metas semanales.',
        scheduledDateTime: DateTime(targetYear, targetMonth, targetDay, 11, 30),
        category: AgendaCategory.estudioTrabajo,
        isCompleted: true,
        createdAt: DateTime(targetYear, targetMonth, targetDay, 7, 30),
      ),
      AgendaActivity(
        id: 'activity-3',
        title: 'Caminata al aire libre sin pantallas',
        subtitle: '25 min en el parque para despejar la vista y desconectar.',
        scheduledDateTime: DateTime(targetYear, targetMonth, targetDay, 16, 0),
        category: AgendaCategory.saludMental,
        isCompleted: false,
        createdAt: DateTime(targetYear, targetMonth, targetDay, 8, 0),
      ),
      AgendaActivity(
        id: 'activity-4',
        title: 'Escribir en mi Diario Personal de gratitud',
        subtitle: 'Anotar 3 momentos significativos vividos hoy.',
        scheduledDateTime: DateTime(targetYear, targetMonth, targetDay, 21, 30),
        category: AgendaCategory.autocuidado,
        isCompleted: false,
        createdAt: DateTime(targetYear, targetMonth, targetDay, 8, 30),
      ),
    ];
  }

  /// Retorna una copia de las actividades
  Future<List<AgendaActivity>> getActivities() async {
    return List<AgendaActivity>.from(_activities);
  }

  /// Guarda o actualiza una actividad
  Future<void> saveActivity(AgendaActivity activity) async {
    final index = _activities.indexWhere((a) => a.id == activity.id);
    if (index >= 0) {
      _activities[index] = activity;
    } else {
      _activities.add(activity);
    }
  }

  /// Conmuta el estado de completada
  Future<void> toggleActivityCompletion(String id) async {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index >= 0) {
      final current = _activities[index];
      _activities[index] = current.copyWith(isCompleted: !current.isCompleted);
    }
  }

  /// Elimina una actividad
  Future<void> deleteActivity(String id) async {
    _activities.removeWhere((a) => a.id == id);
  }
}


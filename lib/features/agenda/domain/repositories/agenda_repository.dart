import '../entities/agenda_activity.dart';

/// Interfaz abstracta del repositorio de agenda (Capa de Dominio).
abstract class AgendaRepository {
  /// Obtiene la lista completa de actividades planificadas
  Future<List<AgendaActivity>> getActivities();

  /// Guarda una nueva actividad o actualiza una existente
  Future<void> saveActivity(AgendaActivity activity);

  /// Conmuta el estado de completada de una actividad por su ID
  Future<void> toggleActivityCompletion(String id);

  /// Elimina una actividad por su ID
  Future<void> deleteActivity(String id);
}


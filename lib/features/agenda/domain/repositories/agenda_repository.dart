import '../entities/agenda_activity.dart';

/// Interfaz abstracta del repositorio de agenda (Capa de Dominio).
/// Permite recuperar y gestionar actividades aisladas por usuario.
abstract class AgendaRepository {
  /// Obtiene la lista completa de actividades planificadas para un usuario
  Future<List<AgendaActivity>> getActivities([String userId = '']);

  /// Guarda una nueva actividad o actualiza una existente
  Future<void> saveActivity(AgendaActivity activity);

  /// Conmuta el estado de completada de una actividad por su ID
  Future<void> toggleActivityCompletion(String id, [String userId = '']);

  /// Elimina una actividad por su ID
  Future<void> deleteActivity(String id, [String userId = '']);
}

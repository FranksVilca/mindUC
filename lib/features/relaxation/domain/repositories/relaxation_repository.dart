import '../entities/relaxation_activity.dart';

/// Contrato del repositorio para la gestión del progreso y persistencia del módulo de Relajación.
abstract interface class RelaxationRepository {
  /// Obtiene la lista de actividades con el estado de progreso aislado del usuario autenticado.
  Future<List<RelaxationActivity>> getActivities({required String userId});

  /// Registra la culminación exitosa de una rutina para el usuario.
  Future<void> saveActivityCompletion({
    required String userId,
    required String activityId,
  });

  /// Restablece el progreso diario del usuario si fuera requerido.
  Future<void> resetDailyProgress({required String userId});
}

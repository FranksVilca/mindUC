import '../entities/progress_summary_state.dart';

/// Contrato abstracto del repositorio de Progreso & Florecimiento (Principio I).
/// Permite recuperar y actualizar métricas de bienestar compasivo aisladas por usuario.
abstract class ProgressRepository {
  /// Obtiene el estado consolidado de progreso del estudiante autenticado
  Future<ProgressSummaryState> getProgressSummary([String userId = '']);

  /// Conmuta o incrementa el avance de una intención semanal para un usuario
  Future<ProgressSummaryState> toggleIntentionProgress(
    String intentionId, [
    String userId = '',
  ]);

  /// Incrementa el contador de sesiones Pomodoro completadas
  Future<void> incrementPomodoroSession([String userId = '']);

  /// Acumula minutos de respiración guiada consciente
  Future<void> recordBreathingMinutes(int minutes, [String userId = '']);

  /// Actualiza el recuento de huellas en el diario interior
  Future<void> updateJournalEntriesCount(int count, [String userId = '']);
}

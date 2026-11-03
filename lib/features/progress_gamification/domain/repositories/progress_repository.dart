import '../entities/progress_summary_state.dart';

/// Contrato abstracto del repositorio de Progreso & Florecimiento (Principio I).
abstract class ProgressRepository {
  /// Obtiene el estado consolidado de progreso del estudiante
  Future<ProgressSummaryState> getProgressSummary();

  /// Conmuta o incrementa el avance de una intención semanal
  Future<ProgressSummaryState> toggleIntentionProgress(String intentionId);
}


import '../../domain/entities/progress_summary_state.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/local_progress_datasource.dart';

/// Implementación del repositorio de Progreso & Florecimiento con almacenamiento local.
class LocalProgressRepositoryImpl implements ProgressRepository {
  final LocalProgressDataSource _dataSource;

  LocalProgressRepositoryImpl({LocalProgressDataSource? dataSource})
      : _dataSource = dataSource ?? LocalProgressDataSource();

  @override
  Future<ProgressSummaryState> getProgressSummary([String userId = '']) {
    return _dataSource.getProgressSummary(userId);
  }

  @override
  Future<ProgressSummaryState> toggleIntentionProgress(
    String intentionId, [
    String userId = '',
  ]) {
    return _dataSource.toggleIntentionProgress(intentionId, userId);
  }

  @override
  Future<void> incrementPomodoroSession([String userId = '']) {
    return _dataSource.incrementPomodoroSession(userId);
  }

  @override
  Future<void> recordBreathingMinutes(int minutes, [String userId = '']) {
    return _dataSource.recordBreathingMinutes(minutes, userId);
  }

  @override
  Future<void> updateJournalEntriesCount(int count, [String userId = '']) {
    return _dataSource.updateJournalEntriesCount(count, userId);
  }
}

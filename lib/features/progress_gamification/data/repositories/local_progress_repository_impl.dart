import '../../domain/entities/progress_summary_state.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/local_progress_datasource.dart';

/// Implementación del repositorio de Progreso & Florecimiento con almacenamiento local.
class LocalProgressRepositoryImpl implements ProgressRepository {
  final LocalProgressDataSource _dataSource;

  LocalProgressRepositoryImpl({LocalProgressDataSource? dataSource})
      : _dataSource = dataSource ?? LocalProgressDataSource();

  @override
  Future<ProgressSummaryState> getProgressSummary() {
    return _dataSource.getProgressSummary();
  }

  @override
  Future<ProgressSummaryState> toggleIntentionProgress(String intentionId) {
    return _dataSource.toggleIntentionProgress(intentionId);
  }
}


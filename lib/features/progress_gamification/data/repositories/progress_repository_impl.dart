import '../../../../core/firebase/firebase_initializer.dart';
import '../../domain/entities/progress_summary_state.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/firestore_progress_datasource.dart';
import '../datasources/local_progress_datasource.dart';

/// Implementación del repositorio de Progreso & Florecimiento con soporte
/// para Cloud Firestore y fallback local resiliente.
class ProgressRepositoryImpl implements ProgressRepository {
  final FirestoreProgressDataSource _firestoreDataSource;
  final LocalProgressDataSource _localDataSource;

  ProgressRepositoryImpl({
    FirestoreProgressDataSource? firestoreDataSource,
    LocalProgressDataSource? localDataSource,
  })  : _firestoreDataSource =
            firestoreDataSource ?? FirestoreProgressDataSource(),
        _localDataSource = localDataSource ?? LocalProgressDataSource();

  bool get _useFirestore => FirebaseInitializer.isInitialized;

  @override
  Future<ProgressSummaryState> getProgressSummary([String userId = '']) async {
    if (_useFirestore) {
      try {
        final summary = await _firestoreDataSource.getProgressSummary(userId);
        return summary;
      } catch (_) {}
    }
    return _localDataSource.getProgressSummary(userId);
  }

  @override
  Future<ProgressSummaryState> toggleIntentionProgress(
    String intentionId, [
    String userId = '',
  ]) async {
    final localResult =
        await _localDataSource.toggleIntentionProgress(intentionId, userId);
    if (_useFirestore) {
      try {
        final firestoreResult = await _firestoreDataSource
            .toggleIntentionProgress(intentionId, userId);
        return firestoreResult;
      } catch (_) {}
    }
    return localResult;
  }

  @override
  Future<void> incrementPomodoroSession([String userId = '']) async {
    await _localDataSource.incrementPomodoroSession(userId);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.incrementPomodoroSession(userId);
      } catch (_) {}
    }
  }

  @override
  Future<void> recordBreathingMinutes(int minutes, [String userId = '']) async {
    await _localDataSource.recordBreathingMinutes(minutes, userId);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.recordBreathingMinutes(minutes, userId);
      } catch (_) {}
    }
  }

  @override
  Future<void> updateJournalEntriesCount(int count, [String userId = '']) async {
    await _localDataSource.updateJournalEntriesCount(count, userId);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.updateJournalEntriesCount(count, userId);
      } catch (_) {}
    }
  }
}

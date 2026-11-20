import '../../../../core/firebase/firebase_initializer.dart';
import '../../domain/entities/relaxation_activity.dart';
import '../../domain/repositories/relaxation_repository.dart';
import '../datasources/firestore_relaxation_datasource.dart';
import '../datasources/local_relaxation_datasource.dart';

/// Implementación del repositorio de relajación con soporte dual:
/// Cloud Firestore para sincronización en la nube y LocalRelaxationDataSource como respaldo offline.
class RelaxationRepositoryImpl implements RelaxationRepository {
  final FirestoreRelaxationDataSource _firestoreDataSource;
  final LocalRelaxationDataSource _localDataSource;

  RelaxationRepositoryImpl({
    FirestoreRelaxationDataSource? firestoreDataSource,
    LocalRelaxationDataSource? localDataSource,
  })  : _firestoreDataSource =
            firestoreDataSource ?? FirestoreRelaxationDataSource(),
        _localDataSource = localDataSource ?? LocalRelaxationDataSource();

  bool get _useFirestore => FirebaseInitializer.isInitialized;

  @override
  Future<List<RelaxationActivity>> getActivities({required String userId}) async {
    Map<String, int> counts = {};

    if (_useFirestore) {
      try {
        counts = await _firestoreDataSource.getCompletionsToday(userId);
      } catch (_) {}
    }

    if (counts.isEmpty) {
      counts = await _localDataSource.getCompletionsToday(userId);
    }

    return RelaxationActivity.defaultActivities.map((activity) {
      final userCount = counts[activity.id] ?? 0;
      return activity.copyWith(
        isCompletedToday: userCount > 0,
        completionsCount: userCount,
      );
    }).toList();
  }

  @override
  Future<void> saveActivityCompletion({
    required String userId,
    required String activityId,
  }) async {
    await _localDataSource.recordCompletion(userId, activityId);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.recordCompletion(userId, activityId);
      } catch (_) {}
    }
  }

  @override
  Future<void> resetDailyProgress({required String userId}) async {
    await _localDataSource.clearUserProgress(userId);
    if (_useFirestore) {
      try {
        await _firestoreDataSource.clearUserProgress(userId);
      } catch (_) {}
    }
  }
}

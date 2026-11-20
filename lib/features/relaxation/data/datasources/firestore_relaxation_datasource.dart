import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/firebase/firebase_service.dart';

/// Fuente de datos de Cloud Firestore para el progreso del módulo de Relajación y Pausas Activas.
/// Almacena las rutinas completadas en `users/{userId}/relaxation_progress/{activityId}`.
class FirestoreRelaxationDataSource {
  final FirebaseService _firebaseService;

  FirestoreRelaxationDataSource({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService.instance;

  CollectionReference<Map<String, dynamic>> _collection(String userId) =>
      _firebaseService.relaxationCollection(userId);

  /// Recupera los conteos de realización de rutinas de hoy para el usuario
  Future<Map<String, int>> getCompletionsToday(String userId) async {
    final cleanUid =
        userId.trim().isEmpty ? _firebaseService.currentUserId : userId.trim();
    final snapshot = await _collection(cleanUid).get();

    final result = <String, int>{};
    for (final doc in snapshot.docs) {
      final count = (doc.data()['completionsCount'] as int?) ?? 0;
      result[doc.id] = count;
    }
    return result;
  }

  /// Registra la realización de una actividad de relajación
  Future<void> recordCompletion(String userId, String activityId) async {
    final cleanUid =
        userId.trim().isEmpty ? _firebaseService.currentUserId : userId.trim();

    await _collection(cleanUid).doc(activityId).set({
      'activityId': activityId,
      'completionsCount': FieldValue.increment(1),
      'lastCompletedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Limpia el progreso diario del usuario en un único lote atómico WriteBatch
  Future<void> clearUserProgress(String userId) async {
    final cleanUid =
        userId.trim().isEmpty ? _firebaseService.currentUserId : userId.trim();
    final snapshot = await _collection(cleanUid).get();
    if (snapshot.docs.isEmpty) return;

    final batch = _firebaseService.firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}

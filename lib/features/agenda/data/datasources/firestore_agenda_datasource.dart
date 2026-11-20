import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/entities/agenda_activity.dart';

/// Fuente de datos de Cloud Firestore para la Agenda Consciente.
/// Almacena y sincroniza las actividades en la subcolección:
/// `users/{userId}/activities/{activityId}`
class FirestoreAgendaDataSource {
  final FirebaseService _firebaseService;

  FirestoreAgendaDataSource({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService.instance;

  CollectionReference<Map<String, dynamic>> _collection(String userId) =>
      _firebaseService.agendaCollection(userId);

  /// Recupera todas las actividades del usuario ordenadas por fecha y hora programada
  Future<List<AgendaActivity>> getActivities(String userId) async {
    final snapshot = await _collection(userId)
        .orderBy('scheduledDateTime', descending: false)
        .get();

    return snapshot.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());
      data['id'] = doc.id;
      return AgendaActivity.fromJson(data);
    }).toList();
  }

  /// Stream reactivo en tiempo real de las actividades del usuario
  Stream<List<AgendaActivity>> watchActivities(String userId) {
    return _collection(userId)
        .orderBy('scheduledDateTime', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return AgendaActivity.fromJson(data);
      }).toList();
    });
  }

  /// Crea o actualiza una actividad en Cloud Firestore
  Future<void> saveActivity(AgendaActivity activity) async {
    final userId = activity.userId.trim().isEmpty
        ? _firebaseService.currentUserId
        : activity.userId.trim();

    final data = activity.toJson();
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _collection(userId).doc(activity.id).set(
          data,
          SetOptions(merge: true),
        );
  }

  /// Conmuta atómicamente el estado de completitud de una actividad mediante transacción
  Future<void> toggleActivityCompletion(String id, String userId) async {
    final docRef = _collection(userId).doc(id);
    await _firebaseService.firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;
      final current = snapshot.data()?['isCompleted'] as bool? ?? false;
      transaction.update(docRef, {
        'isCompleted': !current,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Elimina una actividad de la agenda
  Future<void> deleteActivity(String id, String userId) async {
    await _collection(userId).doc(id).delete();
  }
}

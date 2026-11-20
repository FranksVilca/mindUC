import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/firebase/firebase_service.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/journal_mood_pulse.dart';

/// Fuente de datos de Cloud Firestore para el Diario Personal Íntimo.
/// Almacena y sincroniza reflexiones privadas en:
/// `users/{userId}/journal_entries/{entryId}`
class FirestoreJournalDataSource {
  final FirebaseService _firebaseService;

  FirestoreJournalDataSource({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService.instance;

  CollectionReference<Map<String, dynamic>> _collection(String userId) =>
      _firebaseService.journalCollection(userId);

  /// Recupera las reflexiones del usuario ordenadas cronológicamente (más recientes primero)
  Future<List<JournalEntry>> getEntries(String userId) async {
    final snapshot = await _collection(userId)
        .orderBy('createdAtMillis', descending: true)
        .get();

    return snapshot.docs.map((doc) => _fromFirestore(doc.data(), doc.id)).toList();
  }

  /// Stream reactivo en tiempo real de las reflexiones del usuario
  Stream<List<JournalEntry>> watchEntries(String userId) {
    return _collection(userId)
        .orderBy('createdAtMillis', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => _fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  /// Guarda o actualiza una reflexión en Cloud Firestore
  Future<void> saveEntry(JournalEntry entry) async {
    final userId = entry.userId.trim().isEmpty
        ? _firebaseService.currentUserId
        : entry.userId.trim();

    final data = _toFirestore(entry);
    data['updatedAtMillis'] = DateTime.now().millisecondsSinceEpoch;

    await _collection(userId).doc(entry.id).set(
          data,
          SetOptions(merge: true),
        );
  }

  /// Elimina una reflexión definitivamente
  Future<void> deleteEntry(String id, String userId) async {
    await _collection(userId).doc(id).delete();
  }

  Map<String, dynamic> _toFirestore(JournalEntry entry) {
    return {
      'id': entry.id,
      'userId': entry.userId,
      'title': entry.title,
      'content': entry.content,
      'moodPulse': entry.moodPulse.name,
      'createdAtMillis': entry.createdAt.millisecondsSinceEpoch,
      'updatedAtMillis': entry.updatedAt?.millisecondsSinceEpoch,
    };
  }

  JournalEntry _fromFirestore(Map<String, dynamic> data, String id) {
    final pulseName = data['moodPulse'] as String?;
    final pulse = JournalMoodPulse.values.firstWhere(
      (p) => p.name == pulseName,
      orElse: () => JournalMoodPulse.enCalma,
    );

    final createdMillis = data['createdAtMillis'] as int? ??
        (data['createdAt'] is Timestamp
            ? (data['createdAt'] as Timestamp).millisecondsSinceEpoch
            : DateTime.now().millisecondsSinceEpoch);

    final updatedMillis = data['updatedAtMillis'] as int? ??
        (data['updatedAt'] is Timestamp
            ? (data['updatedAt'] as Timestamp).millisecondsSinceEpoch
            : null);

    return JournalEntry(
      id: id,
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      moodPulse: pulse,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdMillis),
      updatedAt: updatedMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(updatedMillis)
          : null,
    );
  }
}
